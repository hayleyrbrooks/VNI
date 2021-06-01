# Quality analysis for VNI MRI behavior dataset
# (e.g. how many missed trials? how many missed attention checks? individual-level glm)

# output:
# 1) behQualCheck.Rdata - for each sub, total and proportion of "no mans land" choices, total and proportion of choices where safe = 0 and partiicipants took the gamble
# 2) subID_exclude.Rdata - which participants are we excluding (1 = exclude; 0 = keep)
# 3) subChoices.pdf - each participant's choices over the task and as a function of safe x risky gain, pgamble included

# Hayley Brooks
# 10/22/21
# Sokol-Hessner Lab
# University of Denver

rm(list = ls());

library('config');

vniBeh = read.csv("/Volumes/shlab/Projects/VNI/data/mriBehaviorRaw/groupLevelFiles/mriBehaviorRawCombined.csv");

sem <- function(x) sd(x)/sqrt(length(x)); # function for calculating standard error of the mean

# remove subject #13 (did not start task)
ind13 = which(vniBeh$subjectIndex==13);
vniBeh = vniBeh[-ind13,];


nSub = length(unique(vniBeh$subjectIndex));
subNum = unique(vniBeh$subjectIndex);

nanInd = which(is.na(vniBeh$choice));
totNan = length(nanInd); # 133 missed trials 11/11
subNan = unique(vniBeh$subjectIndex[nanInd]); #(11/11; 25 subs with missed trials)

missTri = matrix(data=NA, nrow = nSub, ncol=2, dimnames = list(c(NULL), c("subID", "totMiss")))

for (s in 1:nSub){
  missTri[s,1] = subNum[[s]]
  missTri[s,2] = sum(vniBeh$subjectIndex[nanInd] == subNum[s]);
};

mean(missTri[,2]); #11/11 mean missed trial = 2.61; range = 0 - 49 trials; median = 0

vniBeh = vniBeh[which(!is.nan(vniBeh$choice)),]; #remove missed trials

#how many trials does each person have now that we have cleaned the data?
T1 = c(1,which(diff(vniBeh$subjectIndex)==1) + 1); #which row in vniData is each participants 1st trial?
nTxSub = vector(length=nSub); # to store each participants number of trials
for (n in 1:nSub){
  nTxSub[n] = sum(vniBeh$subjectIndex==subNum[n])
};


#PLOT PARTICIPANTS CHOICES AND CALCULATE PGAMBLE
plotChoices<- function(data,subnum){
  subjectn = data[data$subjectIndex==subnum,]; # pull out subject data
  maxAlt = max(subjectn$alternative); #max alternative value for this subject
  subP = round(mean(subjectn$choice),digits = 2); #find the probabilit of gambling
  ind0 = which(subjectn$outcome==0); #which outcomes were zeroes (gamble taken and not won)

  #par(mfrow = c(1,2), mai = c(1,1,1,.25)); # settings for plot
  par(mfrow=c(1,2))#,oma = c(0, 0, .5, 0))
  plot(subjectn$alternative, col = subjectn$choice/.55+2, xlab="Trial", ylab = "Alternative ($)", ylim = c(0,31), cex.axis=1, cex.main = 1, cex.lab = 1, main = sprintf("Choice set across task\n  sub %g p(gamble)= %g", subnum, subP)); #plot alternative, gambles taken are in green
  points(subjectn$groundEV, col = "black", pch = "-"); # plot ground EV
  points(ind0, subjectn$alternative[ind0], col = "darkgreen", pch = 1);#dark green = gamble not won

  plot(subjectn$riskyGain, subjectn$alternative, col = subjectn$choice/.55+2, xlab="Risky gain ($)", ylab="Alternative ($)", main="Risky gain x Alternative\ngreen = accept; red = reject", cex.axis=1, cex.main = 1, cex.lab = 1, ylim = c(0,31), xlim = c(0,65))
  #points(ind0, subjectn$alternative[ind0], col = "darkgreen", pch = 1);#dark green = gamble not won
};

# PLOT AND SAVE CHOICES ACROSS THE TASK AND ACROSS GAIN & SAFE VALUES
pdf("/Volumes/shlab/Projects/VNI/analysis/mriBehaviorAnalysis/figures/subChoices.pdf", width = 7, height = 3.5)
subP = vector();

for(p in 1:nSub){
  plotChoices(vniBeh,subNum[p])
  subjectn = vniBeh[vniBeh$subjectIndex==subNum[p],]
  subP[p] = round(mean(subjectn$choice), digits = 3)
};

dev.off();

# 11/11 n = 51
# mean pgam = .43
# range = .01 - .85

# some quality checks for now
nmlChoices = matrix(data=NA, nrow = nSub, ncol = 5, dimnames=list(c(NULL),c("subID", "nmlGam","nmlTot","safe0gam", "safe0Tot")));
subModels = list();
for(s in 1:nSub){
  sub = vniBeh[vniBeh$subjectIndex==subNum[s],];
  nmlInd1 = which(sub$alternative >= sub$riskyGain);
  nmlChoices[s,1] = subNum[s]
  nmlChoices[s,2] = mean(sub$choice[nmlInd1]); # 0 = no gamble on any nml choices; >0 gambled on at least one nml choice
  nmlChoices[s,3] = length(nmlInd1); # how many choices in "no man's land"

  nmlInd2 = which(sub$alternative==0);

  nmlChoices[s,4] = mean(sub$choice[nmlInd2]); #1=gambled on all, <1 = took safe atleast once; Nan = there were no choices were alternative was =0 (this was a coding error that was fixed after sub 11)
  nmlChoices[s,5] = length(nmlInd2); # how many choices where alternative =0?

  subModels[[s]] = glm(choice~gainSC + altSC, data=sub, family="binomial");

};

# Notes: updated 11/11
# all subs (except 16) show individual models that reflect they were paying attention
# sub 016 -> estimates are right valence-wise but betas are not significant - this person only took 4 gambles the entire time (pgam = .02) - lots of motion in functional data
#sub 006 missed 4/16 (25%) attention check choices
#sub 021,  031 missed 1/13 (.07%) attention check choices
#sub 026 missed 1/15 nml choices
#sub 042 missed 49 trials, pgamble = .85
#sub 043 had a pgamble of .009 and did not have significant betas for gains and loss in glm, and played it safe on one trial where they should have gambled.
# sub 047 gambled on 2 of the 12 choices where they should not have


# create a file with subject ID numbers and note which subs should be excluded
subID_exclude = as.data.frame(matrix(data=NA, nrow=52,ncol=2, dimnames=list(c(NULL),c("subID", "exclude"))));
subID_exclude$subID = 1:52;
subID_exclude$exclude[c(13,16,42,43)] = 1; # excluded participants = 1
subID_exclude$exclude[-c(13,16,42,43)]=0;  # included participants = 0


# save the output for the quality analysis
save(file="/Volumes/shlab/Projects/VNI/data/mriBehaviorQAoutput/behQualCheck.Rdata",nmlChoices);
save(file="/Volumes/shlab/Projects/VNI/data/mriBehaviorQAoutput/subID_exclude.Rdata", subID_exclude);


