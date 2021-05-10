# Generalized linear mixed effects model for vni MRI behavioral data
# 7/1/20
# Hayley Brooks
# Sokol-Hessner Lab
# University of Denver

# last analysis was done on 10/23, n = 39 - SINCE THEN WE ARE NOT USING RESID BUT OFFSET AND WE HAVE 48 PARTICIPANTS


# output
  # 1) indivPOCestimates.pdf - plots each sub's past outcome betas
  # 2) runSizeShiftFigs.pdf- plots change in risk taking following negative shift as a function of shift and run size
  # 3) ocEarnIntxOnly.pdf - risk taking as a fucntion of outcomes x earnings plotting only interaction
  # 4) ocEarnIntx.pdf - risk taking as a function of outcomes x earnings interaction plotting all variables in the model
  # 5) taskEarnings.pdf - earnings for each participant over the task


# clear environment
rm(list = ls())

# load packages
library(lme4);
library(lmerTest);

# load data
load("/Volumes/shlab/Projects/VNI/data/mriBehaviorClean/group_mriBehavior_clean.Rdata"); 

nSub = length(unique(vniBeh$subjectIndex)); # n=39   10/23
subNum = unique(vniBeh$subjectIndex);


# FOR THIS ANALYSIS, WE WANT TO KNOW IF RISK TAKING (RESIDUALS) CHANGES AS A FUNCTION OF TEMPORAL CONTEXT AT THREE LEVELS:
# 1) PAST OUTCOME (IMMEDIATE)
# 2) SHIFTS (NEIGHBORHOOD)
# 3) CUMULATIVE EARNINGS (GLOBAL)


# INDIVIDUAL-LEVEL ANALYSES
# DOES RISK-TAKING CHANGE ON THE IMMEDIATE LEVEL OF TEMPORAL CONTEXT?
  # Iindividual-level past outcome glms
subsTriLevMods = list();
subsPocMods = list();
triLevResults = matrix(data = NA, nrow = nSub, ncol=3, dimnames=list(c(NULL), c("subID","beta","pval")))
pocResults = matrix(data = NA, nrow = nSub, ncol=3, dimnames=list(c(NULL), c("subID","beta","pval")))

for (s in 1:nSub) {
  sub = vniBeh[vniBeh$subjectIndex==subNum[s],];
  
  subsTriLevMods[[s]] = glm(choice~gainSC + altSC + grndEVscaled, data=sub, family="binomial");
  #subsTriLevMods[[s]] = glm(choice~gainSC + altSC, data=sub, family="binomial");

  sub$triLevResids= residuals(subsTriLevMods[[s]], type="response")
  
  subsPocMods[[s]] = lm(triLevResids~poc1scaled, data=sub)
  tmp = summary(subsPocMods[[s]])[4]; #store coefficients from poc model
  pocResults[s,1] = subNum[s]
  pocResults[s,2:3] = c(tmp$coefficients[2], tmp$coefficients[8])

}; 

# plot the past outcome individual-level
pdf("/Volumes/shlab/Projects/VNI/analysis/mriBehaviorAnalysis/figures/indivPOCestimates.pdf")
plot(pocResults[,2], ylim=c(-.5,.5), pch=16, main=sprintf("Individual past outcome estimates (n=%s)", nSub), xlab="participant", ylab="estimate", col= ifelse(pocResults[,3]<.05, "green", ifelse(pocResults[,3]<.1 & pocResults[,3]>.05,"blue", "black")), cex=1.75); # blue is trending, green is significant, black is neither
abline(a=0,b=0, col="grey")
dev.off();
# SUMMARY - 10/23/30 N=39
# After accounting for trial-level effects (gain, safe, EV), there are 4 participants showing significant effects of past outcome (3 with positive betas, 1 with negative beta). There are 4 additional participants with trending effects of past outcome (3 with positive betas, 1 with negative beta). I also ran a trial-level model with just gain and safe (because ground EV was causing some weird patterns for some participants in those individual-level trial-level glms) and the results are similar but now there are 4 participants showing significant effects of past outcome (3 positive, 1 negative) and 6 participants with trending effect of past outcome (4 positive, 2 negative). 



# GROUP-LEVEL ANALYSES

# trial-level model, pull out the residuals:
m1 = glmer(choice~ 0 + gainSC + altSC + grndEVscaled + (0+ gainSC + altSC|subjectIndex), data = vniBeh, family = "binomial");
# this model is identical to what we used in VIC - allowing gain and safe to vary by participant

# allowing gain and safe to vary by person
#10/23/20, n=39
#AIC = 6349.5
#gainSC         17.367      2.184   7.954 1.81e-15 ***
#altSC         -42.253      4.297  -9.834  < 2e-16 ***
#grndEVscaled    5.210      5.911   0.881    0.378  
# when we allow ground ev to also vary by person, the model is singular and AIC is higher at 6353.9

# ADD INTERCEPT
#m1intercept = glmer(choice~ 1+ gainSC + altSC + grndEVscaled + (gainSC + altSC|subjectIndex), data = vniBeh, family = "binomial");
#10/23/20, n=39
# AIC = 6753.0
#(Intercept)   -0.1506     0.1877  -0.802   0.4223    
#gainSC        12.1767     1.5574   7.819 5.33e-15 ***
#altSC        -37.0425     3.1452 -11.778  < 2e-16 ***
#grndEVscaled  11.2363     6.2104   1.809   0.0704 . 

# allowing gain and safe to vary by participant - model does not converge but AIC is lowest = 6266.4
# (Intercept)   -0.05159    0.15848  -0.326    0.745    
# gainSC        17.04496    2.20810   7.719 1.17e-14 ***
# altSC        -44.27705    4.48827  -9.865  < 2e-16 ***
# grndEVscaled   8.10159    6.22841   1.301    0.193    


# PULL OUT THE RESIDUALS FROM TRIAL-LEVEL MODEL
#  residuals from M1 no intercept, allowing gain and safe to vary (NOT the model with the intercept)
vniBeh$triLevResids = residuals(m1,type="response"); #10/23 mean residuals -.002, range= -.999251 to +.999882
par(mfrow=c(1,1))
plot(vniBeh$triLevResids);


# DOES PAST OUTCOME ACCOUNT FOR RESIDUAL RISK-TAKING?
m2poc = lmer(triLevResids ~ 0 + poc1scaled + (1|subjectIndex), data=vniBeh, REML=F);
#10/23, n=39
# poc1scaled beta = 9.916e-03(1.115e-02) p = 0.375
#AIC = 5259.2
# not seeing an effect of past outcome amount here

# what about outcome type:
m2poctype = lmer(triLevResids ~0 + poc1type + (1|subjectIndex), data=vniBeh, REML=F); # win = 1, loss = -1, safe = 0
#AIC = 5257.4 
#poc1type 8.767e-03  5.470e-03 8.443e+03   1.603    0.109

# DOES SHIFT ACCOUNT FOR RESIDUAL RISK-TAKING?
# in previous datasets, we've seen an asymmetrical effect of positive shift only and the effect is usually short-lasting.

m3shift = lmer(triLevResids ~ 0 + shiftDiffsc + (1|subjectIndex), data=vniBeh, REML=F);
# shiftDiffsc beta =7.521e-02 (6.466e-02) p= 0.245

m3shiftAbs = lmer(triLevResids ~ 0 + shiftDiffscABs + (1|subjectIndex), data=vniBeh, REML=F);
# shiftDiffscABs beta =5.239e-02(6.513e-02) , p=0.421

m3shiftPOS = lmer(triLevResids ~ 0 + shiftDiffscPOS + (1|subjectIndex), data=vniBeh, REML=F);
# shiftDiffscPOS 1.278e-01  9.177e-02 7.470e+03   1.392    0.164

m3shiftPOSind = lmer(triLevResids ~ 0 + shiftDiffscPOSInd + (1|subjectIndex), data=vniBeh, REML=F);
# shiftDiffscPOSInd 2.187e-02  1.684e-02 6.900e+03   1.299    0.194

m3shiftNEG = lmer(triLevResids ~ 0 + shiftDiffscNEG + (1|subjectIndex), data=vniBeh, REML=F);
# shiftDiffscNEG 2.379e-02  9.177e-02 7.453e+03   0.259    0.795

m3shiftNEGind = lmer(triLevResids ~ 0 + shiftDiffscNEGInd + (1|subjectIndex), data=vniBeh, REML=F);
#shiftDiffscNEGind 5.722e-03  1.684e-02 6.884e+03    0.34    0.734

# QUICK SUMMARY :not seeing a main effect of shift for any of the shift variables (signed, absolute, positive, negative). 

# Could shift effect depend on the preceding run size?
m3shiftRunSize = lmer(triLevResids ~ 0 + shiftDiffsc*runSizeShift + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5336.2
# shiftDiffsc               3.049e-01  2.161e-01  8.483e+03   1.411   0.1583  
# runSizeShift              2.120e-03  1.085e-03  4.560e+03   1.954   0.0508 .
# shiftDiffsc:runSizeShift -2.208e-02  1.969e-02  8.484e+03  -1.121   0.2622  

# interaction is n.s., remove it:
# AIC = 5335.5
#shiftDiffsc  7.368e-02  6.465e-02 8.453e+03    1.14   0.2545  
#runSizeShift 2.072e-03  1.085e-03 4.574e+03    1.91   0.0562 .

m3shiftABSRunSize = lmer(triLevResids ~ 0 + shiftDiffscABs*runSizeShift + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5336.3
# shiftDiffscABs              -2.473e-01  2.161e-01  8.487e+03  -1.144   0.2525  
# runSizeShift                 4.403e-03  2.399e-03  8.333e+03   1.835   0.0665 .
# shiftDiffscABs:runSizeShift  7.203e-03  2.305e-02  8.492e+03   0.312   0.7547  

# since interaction is not significant, remove it:
#AIC = 5334.4  
#shiftDiffscABs -1.917e-01  1.230e-01  8.479e+03  -1.559   0.1189  
#runSizeShift    4.794e-03  2.047e-03  8.437e+03   2.342   0.0192 *

m3shiftPOSrunSize = lmer(triLevResids ~ 0 + shiftDiffscPOS*runSizeShift + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5338.7
# shiftDiffscPOS               6.035e-02  3.101e-01  8.492e+03   0.195    0.846
# runSizeShift                 1.881e-03  1.400e-03  6.609e+03   1.344    0.179
# shiftDiffscPOS:runSizeShift -2.700e-03  2.837e-02  8.492e+03  -0.095    0.924
# if the interaction is removed, run size is still not significant (p=.175; AIC =  5336.7)

m3shiftNEGrunSize = lmer(triLevResids ~ 0 + shiftDiffscNEG + runSizeShift + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5334.5
# shiftDiffscNEG               5.203e-01  3.025e-01  8.491e+03   1.720   0.0855 .
# runSizeShift                 3.021e-03  1.390e-03  6.582e+03   2.174   0.0297 *
# shiftDiffscNEG:runSizeShift -3.382e-02  2.918e-02  8.490e+03  -1.159   0.2464  

# since the interaction is not significant, remove it:
# AIC = 5333.8
#shiftDiffscNEG 1.953e-01  1.135e-01 8.462e+03   1.720   0.0854 .
#runSizeShift   3.445e-03  1.341e-03 6.791e+03   2.568   0.0102 *

# what's going on here? why is run size preceding a shift only significant when in a model with the negative shift variable? what happens if we use the run size variable that only has a run size preceding a negative shift?
m3shiftNEGrunSizeNeg = lmer(triLevResids ~ 0 + shiftDiffscNEG + runSizeNEG + (1|subjectIndex), data=vniBeh, REML=F);

# AIC = 5334.4
# shiftDiffscNEG 3.775e-01  1.704e-01 8.473e+03   2.216   0.0267 *
# runSizeNEG     7.031e-03  2.854e-03 8.490e+03   2.464   0.0138 *

# add the variable for run size preceding a positve shift: 
# AIC = 5333.8
# shiftDiffscNEG 3.770e-01  1.704e-01 8.473e+03   2.213   0.0269 *
# runSizeNEG     7.046e-03  2.853e-03 8.490e+03   2.469   0.0136 *
# runSizePOS     2.431e-03  1.517e-03 7.128e+03   1.603   0.1091  

# add interaction between shift and run size, remove run size preceding positive shift:
#AIC = 5336.1
#shiftDiffscNEG             5.036e-01  3.031e-01  8.491e+03   1.661   0.0967 .
#runSizeNEG                 6.066e-03  3.439e-03  8.479e+03   1.764   0.0778 .
#shiftDiffscNEG:runSizeNEG -1.707e-02  3.393e-02  8.486e+03  -0.503   0.6151  


# # let's look at the effects of negative shift and run size preceding a negative shift (separately) - using estimates from the first model above with negative shift and runSizeNEG (no interaction)
#negative shift diff is coded as negative, so the positive beta would mean less risk-taking following a negative shift and run size is a positive variable so the positive beta for run size means more risk-taking when the participant has just been in a long run of trials, relative to a short run of trials. 

runSize = c(0,6,9,12,15);
negShift = c(0,-5,-10,-15,-20)/max(vniBeh$riskyGain); # scale the negative shifts
pgamRunSize = fixef(m3shiftNEGrunSizeNeg)[2]*runSize;
pgamNegShift = fixef(m3shiftNEGrunSizeNeg)[1]*negShift;

pgamRunSize = pgamRunSize*100; # change variable so it show percentage change
pgamNegShift = pgamNegShift*100;

pdf("/Volumes/shlab/Projects/VNI/analysis/mriBehaviorAnalysis/figures/runSizeShiftFigs.pdf")
plot(pgamNegShift, main=sprintf("Change in risk-taking following negative shift (n=%s)", nSub), xlab="shift size (increasingly negative)", ylab="% change in pgamble", axes = F, pch=16, cex=1.5)
axis(1, at=1:5, labels=c("0","-5", "-10", "-15", "-20"),tck=0);
axis(2, label=T, tck=0);

plot(pgamRunSize, main = sprintf("Change in risk-taking as a function of run\n size preceding a negative shift (n=%s)", nSub), xlab = "run size (trials)", ylab = "% change in pgamble", axes= F, pch = 16, cex=1.5, ylim=c(min(pgamRunSize), max(pgamRunSize)))
axis(1, at =1:5 ,label=c("0","6", "9", "12", "15"), tck=0);
axis(2, at = pgamRunSize, label= round(pgamRunSize, digits = 1), tck=0);
dev.off();

# what happens if runsize preceding any type of shift is in a model alone:
m3runSizeShift = lmer(triLevResids ~ 0 + runSizeShift + (1|subjectIndex), data=vniBeh, REML=F);
# AIC =  5334.8 
# runSizeShift 2.087e-03  1.085e-03 4.575e+03   1.924   0.0544 .

m3runSizeShiftNEG = lmer(triLevResids ~ 0 + runSizeNEG + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5337.3 
# runSizeNEG 1.703e-03  1.537e-03 7.155e+03   1.108    0.268

m3runSizeShiftPOS = lmer(triLevResids ~ 0 + runSizePOS + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5335.9
# runSizePOS 2.421e-03  1.517e-03 7.168e+03   1.596    0.111

# What is the run size preceding a shift accounting for if it is not related to negative shift but is strongest in a model with negative shift? why is the interaction not significant then? and why is run size preceding negative shift not significant on its own in a model.


# DO CUMULATIVE EARNINGS ACCOUNT FOR RESIDUAL RISK-TAKING BEHAVIOR?

# just earnings and trial in a model - both are significant, opposite effects though
m4earnings = lmer(triLevResids~0 + earningsSC + trialSC + (1|subjectIndex), data=vniBeh, REML=F)
# AIC =  5322.1
#earningsSC   0.005734   0.001439 122.296776   3.985 0.000115 ***
#trialSC     -0.317238   0.082960 118.700237  -3.824 0.000211 ***

# add shift and run size since we know these are significant in previous models - all are significant, direction of effects are the same
m4earnShiftRun = lmer(triLevResids~0 + earningsSC + trialSC + shiftDiffscNEG  + runSizeNEG + (1|subjectIndex), data=vniBeh, REML=F);
# AIC = 5320.3
# earningsSC      5.753e-03  1.440e-03  1.211e+02   3.994 0.000112 ***
# trialSC        -3.187e-01  8.301e-02  1.175e+02  -3.840 0.000200 ***
# shiftDiffscNEG  3.957e-01  1.702e-01  8.461e+03   2.325 0.020113 *  
# runSizeNEG      6.610e-03  2.857e-03  8.457e+03   2.314 0.020713 *  

# we know poc interacts with cumulative earnings in other datasets, what about here?
# yes, there is a positive interaction and now a negative effect of outcome on risk-taking
# this is the same as what we've been seeing, where past outcome effect is negative for low and moderate earnings but may even flip when earnings are high. Trial is also significant here.
m4earnShiftRunPOC = lmer(triLevResids~0 + earningsSC*poc1scaled + trialSC + shiftDiffscNEG  + runSizeNEG + (1|subjectIndex), data=vniBeh, REML=F);
  # AIC =  5221.2
  # earningsSC             4.428e-03  1.442e-03  1.292e+02   3.071 0.002605 ** 
  # poc1scaled            -8.315e-02  2.166e-02  1.060e+03  -3.839 0.000131 ***
  # trialSC               -2.674e-01  8.240e-02  1.273e+02  -3.245 0.001500 ** 
  # shiftDiffscNEG         3.888e-01  1.697e-01  8.424e+03   2.292 0.021950 *  
  # runSizeNEG             6.783e-03  2.845e-03  8.421e+03   2.384 0.017134 *  
  # earningsSC:poc1scaled  3.486e-03  7.113e-04  2.291e+03   4.901 1.02e-06 ***

# check is there is also an interaction between trial and past outcome
# interaction between trial and past outcome is trending and now neither earnings or trial have main effect
m4earnShiftRunPOC2 = lmer(triLevResids~0 + earningsSC*poc1scaled + trialSC*poc1scaled + shiftDiffscNEG + runSizeNEG + (1|subjectIndex), data=vniBeh, REML=F);
# AIC =  5219.5
# earningsSC             1.451e-03  2.113e-03  5.911e+02   0.687 0.492553    
# poc1scaled            -8.114e-02  2.168e-02  1.033e+03  -3.742 0.000193 ***
# trialSC               -9.401e-02  1.220e-01  5.852e+02  -0.771 0.441175    
# shiftDiffscNEG         3.915e-01  1.696e-01  8.424e+03   2.308 0.021019 *  
# runSizeNEG             6.800e-03  2.844e-03  8.421e+03   2.391 0.016827 *  
# earningsSC:poc1scaled  1.459e-02  5.788e-03  8.434e+03   2.521 0.011736 *  
# poc1scaled:trialSC    -6.504e-01  3.365e-01  8.455e+03  -1.933 0.053277 .  


# plot the interaction between earnings and past outcome (using model m4earnShiftRunPOC)
poc = rep(seq(from=0, to =1, by = .1), times=5);
someEarnings = rep(seq(from=0, to=58, length.out = 5), each=11); #mean max earning= $3550, scaled = $58.21
pocBeta =  fixef(m4earnShiftRunPOC)[2];
earnBeta = fixef(m4earnShiftRunPOC)[1];
pocEarnIntxBeta = fixef(m4earnShiftRunPOC)[6];
resGamAll = pocBeta*poc + earnBeta*someEarnings + pocEarnIntxBeta*poc*someEarnings
resGamItxnOnly = pocEarnIntxBeta*poc*someEarnings

pdf("/Volumes/shlab/Projects/VNI/analysis/mriBehaviorAnalysis/figures/ocEarnIntxOnly.pdf")
par(mar = c(5.1, 4.1, 4.1, 2.1));
plot(resGam[1:11], type="l", lwd=3,col="blue", ylab="residual gambling", xlab = "past outcome", axes=FALSE, main="Outcome (t-1) x Earnings (t)\n earnings: blue ($0) to red ($3,550)", ylim=c(min(resGam), max(resGam))); 
lines(resGam[12:22], col="green",lwd=3);
lines(resGam[23:33], col="purple",lwd=3); 
lines(resGam[34:44], col="orange",lwd=3);
lines(resGam[45:55], col="red", lwd=3);
abline(a=0,b=0, lty="dashed", col="grey");
axis(1, labels = c(0,60), at = c(1,11), lwd=3);
axis(2, labels = c(miny = round(min(resGam),digits=2),maxy = round(max(resGam),digits=2)), at=c(min(resGam),round(max(resGam),digits=2)), lwd=3);
dev.off();
     
pdf("/Volumes/shlab/Projects/VNI/analysis/mriBehaviorAnalysis/figures/ocEarnIntx.pdf")
plot(resGamAll[1:11], type="l", lwd=3,col="blue", ylab="residual gambling", xlab = "past outcome", axes=FALSE, main="Outcome (t-1) x Earnings (t)\n earnings: blue ($0) to red ($3,550)\nincludes oc(t-1) & earnings(t) main effect", ylim=c(min(resGamAll), max(resGamAll))); 
lines(resGamAll[12:22], col="green",lwd=3);
lines(resGamAll[23:33], col="purple",lwd=3); 
lines(resGamAll[34:44], col="orange",lwd=3);
lines(resGamAll[45:55], col="red", lwd=3);
abline(a=0,b=0, lty="dashed", col="grey");
axis(1, labels = c(0,60), at = c(1,11), lwd=3);
axis(2, labels = c(miny = round(min(resGamAll),digits=2),maxy = round(max(resGamAll),digits=2)), at=c(min(resGamAll),round(max(resGamAll),digits=2)), lwd=3);
dev.off();

# plot cumulative earnings for each participant over the task
# range = 3270 - 3938
pdf('/Volumes/shlab/Projects/VNI/analysis/mriBehaviorAnalysis/figures/taskEarnings.pdf')
plot(vniBeh$earnings[vniBeh$subjectIndex==1], type = "l",lwd = 2, ylim = c(0,max(vniBeh$earnings)), xlim= c(0,219), main = "Earnings over the task", ylab = "earnings", xlab="trial number", axes=FALSE)
axis(1, label = c(1, 219), at = c(1,219), tck = 0, lwd = 3)
axis(2, label = c(0, round(max(vniBeh$earnings),digits=0)), at = c(1,max(vniBeh$earnings)), tck = 0, lwd =3)
for(s in 2:nSub){
  points(vniBeh$earnings[vniBeh$subjectIndex==s], type="l", lwd = 1, col = vniBeh$subjectIndex/.2+s)
};
dev.off();
