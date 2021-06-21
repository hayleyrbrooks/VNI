# Clean up VNI MRI behavior dataset (e.g. remove excluded participants, remove NANs, add past outcome variable, etc)
# created 7/1/20
# Hayley Brooks
# Sokol-Hessner Lab
# University of Denver


# output:
# 1) subID_missedT_totalT_pGam_N48.Rdata - number of  missed and total trials for each participant (not including those we are excluding hence the N48) and probability of gambling
# 2) mriBehClean.Rdata - combined dataset across all participants with missed trials removed and variables added (e.g. past outcome)
    # saves a csv version of this ^

# clear envrionment
rm(list = ls());

library("config")
config <- config::get();

# load data
mriBehCleanCSV = file.path(config$path$data$raw_group, config$csvs$RDM_group_raw_csv)
mriBehClean = read.csv(mriBehCleanCSV)
subID_excludePath = file.path(config$path$data$quality_analysis_output, config$Rdata$RDM_exclude)
load(subID_excludePath);

# remove participants using subID_exclude (output from vniMRIbehaviorQA.R)
excludeSub = which(subID_exclude$exclude==1);
excludeInd =  which(mriBehClean$subjectIndex %in% excludeSub); # store trials we are excluding based on subject ID
mriBehClean = mriBehClean[-excludeInd,]; # remove those trials
sum(mriBehClean$subjectIndex %in% excludeSub); # check that it worked, should = 0 because there should be no trials with subject index equal to those included in the exclusion variable

nSub = length(unique(mriBehClean$subjectIndex)); # 48 participants
subNum = unique(mriBehClean$subjectIndex);

nanInd = which(is.na(mriBehClean$choice));
totNan = length(nanInd); # 84 missed trials 11/11
subNan = unique(mriBehClean$subjectIndex[nanInd]); #(11/11; 24 subs with missed trials)

subID_missTri_totTri_pGam = matrix(data=NA, nrow = nSub, ncol=4, dimnames = list(c(NULL), c("subID", "missedTri", "totalTri", "pGam")));

for (s in 1:nSub){
  subID_missTri_totTri_pGam[s,1] = subNum[[s]]
  subID_missTri_totTri_pGam[s,2] = sum(mriBehClean$subjectIndex[nanInd] == subNum[s]);
};

summary(subID_missTri_totTri_pGam[,2]); #10/11 mean missed trial = 1.75; range = 0 - 11 trials; median = .5

mriBehClean = mriBehClean[which(!is.nan(mriBehClean$choice)),]; #remove missed trials

#how many trials does each person have now that we have cleaned the data?
for (n in 1:nSub){
  subID_missTri_totTri_pGam[n,3] = sum(mriBehClean$subjectIndex %in% subNum[n]);
  subID_missTri_totTri_pGam[n,4] = round(mean(mriBehClean$choice[mriBehClean$subjectIndex %in% subNum[n]]), digits = 3)
};


# save this matrix
save(file="/Volumes/shlab/Projects/VNI/data/mriBehaviorQAoutput/subID_missedT_totalT_pGam_N48.Rdata", subID_missTri_totTri_pGam);


# CREATE VARIABLES FOR OUR ANALYSES

# create past outcome variable
newMat = matrix(data=NA,nrow=nrow(mriBehClean), ncol=2)
newMat[,1] <- mriBehClean$outcome; #take data from columns
newMat[2:nrow(newMat),1] <- newMat[1:(nrow(newMat)-1),1]; # removes first row, shifts everything up
newMat[1,1] <- NaN #put Nan in for first row (first trial for subject 1, bc there is no past trial)
newMat[,2]<-c(0,diff(mriBehClean$subjectIndex)); #put differences between NewSubjectIndex into newvector, 1s show up when subject changes
newMat[newMat[,2]==1,]=NaN; #in newmtx, when diff = 1, replace with NaN, this replaces first trial with nan
mriBehClean$poc1 = newMat[,1];# add new vector to capData


# create past outcome variable for outcome type (win = 1, loss = -1, safe = 0)
mriBehClean$poc1type = mriBehClean$outcome;
mriBehClean$poc1type[mriBehClean$outcome == mriBehClean$alternative] = 0;
mriBehClean$poc1type[mriBehClean$outcome == mriBehClean$riskyGain] = 1;
mriBehClean$poc1type[mriBehClean$outcome == mriBehClean$riskyLoss] = -1;

# shift so that this variable captures the past outcome
newMat = matrix(data=NA,nrow=nrow(mriBehClean), ncol=2)
newMat[,1] <- mriBehClean$poc1type; #take data from columns
newMat[2:nrow(newMat),1] <- newMat[1:(nrow(newMat)-1),1]; # removes first row, shifts everything up
newMat[1,1] <- NaN #put Nan in for first row (first trial for subject 1, bc there is no past trial)
newMat[,2]<-c(0,diff(mriBehClean$subjectIndex)); #put differences between NewSubjectIndex into newvector, 1s show up when subject changes
newMat[newMat[,2]==1,]=NaN; #in newmtx, when diff = 1, replace with NaN, this replaces first trial with nan
mriBehClean$poc1type = newMat[,1];# add new vector to


# create a vector that accounts for past outcome by blocks
#mriBehClean$poc1block = mriBehClean$poc1;
#blockDiff = c(0,diff(mriBehClean$block)); # where the block changes
#mriBehClean$poc1block[blockDiff>0] = NaN; # put a NaN for past outcome on the first trial of each block


# create shift variables
mriBehClean$shiftDiff = c(0,diff(mriBehClean$groundEV)); # pulling out the difference in ground EV will get the accurate shift amount = -20 to +20
# * THIS VARIABLE CAPTURES THE FIRST TRIAL IMMEDIATELY FOLLOWING A SHIFT (THE FIRST TRIAL IN A NEW RUN)

# REPLACE THE FIRST TRIAL FOR EACH SUB WITH 0 (OTHERWISE THIS VARIABLE TRACKS SHIFTS ACROSS PEOPLE)
newmtx = matrix(data=NA,nrow = nrow(mriBehClean), ncol = 2); # create new matrix
newmtx[,1] = mriBehClean$shiftDiff ; # store shift diff variable
newmtx[1,1] <- 0 #put 0 in for first row (first trial for subject 1, bc there is no past trial)
newvec <-diff(mriBehClean$subjectIndex); # differenecs between new subject index
newmtx[,2]<-c(0,newvec); # store new vec in newmatx
newmtx[newmtx[,2] > 0,1] = 0; #when difference in sub # is more than 0 (at the start of a new sub), put a zero for the shift diff
mriBehClean$shiftDiff = newmtx[,1]; #put the vector back into mriBehClean

scaleby = max(mriBehClean$riskyGain); # scale the shift diff variable - then the following shift-related variables will be scaled


mriBehClean$shiftDiffsc = mriBehClean$shiftDiff/scaleby; # = -0.3279  to +0.3279
mriBehClean$shiftDiffscABs = abs(mriBehClean$shiftDiffsc); #absolute shift difference: = 0 to +0.3279

# positive shift amount only (negative shifts are 0)
mriBehClean$shiftDiffscPOS = mriBehClean$shiftDiffsc;
mriBehClean$shiftDiffscPOS[mriBehClean$shiftDiffsc < 0] = 0; # positive shift = 0 to .32792

# indices for positive shift only (1/0)
mriBehClean$shiftDiffscPOSInd = mriBehClean$shiftDiffscPOS;
mriBehClean$shiftDiffscPOSInd[mriBehClean$shiftDiffscPOSInd > 0] = 1;

# negative shfit amount only (positive shifts are 0)
mriBehClean$shiftDiffscNEG = mriBehClean$shiftDiffsc;
mriBehClean$shiftDiffscNEG[mriBehClean$shiftDiffsc > 0] = 0; # negative shift = -.32792 to 0

# indices for negative shift only (1/0)
mriBehClean$shiftDiffscNEGInd = mriBehClean$shiftDiffscNEG;
mriBehClean$shiftDiffscNEGInd[mriBehClean$shiftDiffscNEG < 0] = 1;

# Create variable for run size preceding a shift:
# set up the variable
newmtx = matrix(data=NA,nrow = nrow(mriBehClean), ncol = 2); # create new matrix
newmtx[,1] = c(0,mriBehClean$runSize[-c(nrow(mriBehClean))]); # shift everything down one row because we want to see what the run size was prior to the shift, get rid of very last trial for last participant
newmtx[,2]<-c(0,diff(mriBehClean$subjectIndex)); # difference in sub ID, store in temp matrix
newmtx[newmtx[,2] > 0,1] = 0; #when difference in sub # is more than 0 (at the start of a new sub), put a zero for the shift diff
mriBehClean$runSizeAdjust = newmtx[,1]; #put the vector back into mriBehClean

# create the variables for run size following all shifts, positive shift, and negative shifts
mriBehClean$runSizeShift = mriBehClean$runSizeAdjust*as.numeric(mriBehClean$shiftDiff !=0); # how long was the run proceeding any shift?
mriBehClean$runSizePOS = mriBehClean$runSizeAdjust*mriBehClean$shiftDiffscPOSInd; # how long was the run proceeding a positive shift?
mriBehClean$runSizeNEG = mriBehClean$runSizeAdjust*mriBehClean$shiftDiffscNEGInd; # how long was the run proceeding a positive shift?

# scale variables
mriBehClean$poc1scaled = mriBehClean$poc1/scaleby;
#mriBehClean$poc1blkscaled = mriBehClean$poc1block/scaleby;
mriBehClean$grndEVscaled = mriBehClean$groundEV/scaleby;

# recode block (block 1 = 0; block 2 = 1; block 3 = 2)
mriBehClean$blockRecode = mriBehClean$block;
mriBehClean$blockRecode[mriBehClean$blockRecode==1] = 0;
mriBehClean$blockRecode[mriBehClean$blockRecode==2] = 1;
mriBehClean$blockRecode[mriBehClean$blockRecode==3] = 2;


# Create variable for cumulative earnings (scaled) and trial
first = 1; #starting row number
allEarnings = vector(); #vector for storing values for all ps
trialsc = vector(); # scaling trial
earningsNormalized = vector(); # normalizing each person's earnings by their max earnings (0 to 1 for each participant)
indivMaxEarn = vector(mode = "numeric",length=nSub)

for(s in 1:nSub){
  sub = mriBehClean[mriBehClean$subjectIndex==subNum[s],]; #pull out subject
  earnings = vector(); #empty vector to store values for one subject
  tri = 1:nrow(sub)/nrow(sub);
  for(t in 1:nrow(sub)){ #for each trial
    earnings[t] = sum(sub$outcome[1:t]); #calculate total outcomes
  }
  earnings = c(0,earnings[1:length(earnings)-1]); # put zero in first trial, get rid of last trial
  indivMaxEarn[s] = max(earnings); # store participants' max earnings


  last = first+nrow(sub)-1; #last row to store in allcumEarnings
  allEarnings[first:last] = earnings; # store subjects cumulative earnings
  trialsc[first:last] = tri
  earningsNormalized[first:last] = earnings/indivMaxEarn[s]
  first = last +1; #set first to be the row after the previous subjects last trial
};


mriBehClean$trialSC = trialsc # store scaled trial in mriBehClean
mriBehClean$earnings = allEarnings; #store earnings in mriBehClean
mriBehClean$earningsSC = mriBehClean$earnings/scaleby ; #create scaled earnings variable and store it
mriBehClean$earningsNormalized = earningsNormalized # store normalized earnings in mriBehClean


# Create a previous choice variable (0/1)
newMat = matrix(data=NA,nrow=nrow(mriBehClean), ncol=2)
newMat[,1] <- mriBehClean$choice; #take data from columns
newMat[2:nrow(newMat),1] <- newMat[1:(nrow(newMat)-1),1]; # removes first row, shifts everything up
newMat[1,1] <- NaN #put Nan in for first row (first trial for subject 1, bc there is no past trial)
newMat[,2]<-c(0,diff(mriBehClean$subjectIndex)); #put differences between NewSubjectIndex into newvector, 1s show up when subject changes
newMat[newMat[,2]==1,]=NaN; #in newmtx, when diff = 1, replace with NaN, this replaces first trial with nan
mriBehClean$pastChoice = newMat[,1];# add new vector to




# Create a past outcome variable that is recieved-not received
mriBehClean$recievedMinusNot = NA;
mriBehClean$recievedMinusNot = mriBehClean$outcome*mriBehClean$choice # this will store prevous risky win outcome amounts
riskyLossInd = which(mriBehClean$choice==1 & mriBehClean$outcome==mriBehClean$riskyLoss);
safeInd= which(mriBehClean$choice==0 & mriBehClean$outcome==mriBehClean$alternative);
mriBehClean$recievedMinusNot[riskyLossInd] = mriBehClean$outcome[riskyLossInd] - mriBehClean$riskyGain[riskyLossInd];
mriBehClean$recievedMinusNot[safeInd]=mriBehClean$outcome[safeInd];

# scale it
mriBehClean$rcvdMinusNotSC = mriBehClean$recievedMinusNot/scaleby;

# shift it so that it captures the previous trial
newMat = matrix(data=NA,nrow=nrow(mriBehClean), ncol=2)
newMat[,1] <- mriBehClean$rcvdMinusNotSC; #take data from columns
newMat[2:nrow(newMat),1] <- newMat[1:(nrow(newMat)-1),1]; # removes first row, shifts everything up
newMat[1,1] <- NaN #put Nan in for first row (first trial for subject 1, bc there is no past trial)
newMat[,2]<-c(0,diff(mriBehClean$subjectIndex)); #put differences between NewSubjectIndex into newvector, 1s show up when subject changes
newMat[newMat[,2]==1,]=NaN; #in newmtx, when diff = 1, replace with NaN, this replaces first trial with nan
mriBehClean$pocRcvdMinusNotSC = newMat[,1];# add new vector to


# Create a level tracking variable (add the context level up over time) and normalize for each participant by the max level tracking value (result = values 0 to 1)

# Include level tracking variable (adding up levels over time)
subDiff = c(0,diff(mriBehClean$subjectIndex));
levelTracking = vector(); # level tracking variable
levelTrackingNorm = vector(); # for normalized variable
for (s in 1:nSub) {
  sub = mriBehClean[mriBehClean$subjectIndex==subNum[s],];
  tmpvec = cumsum(sub$groundEV); # cumulative the sum of each increasing row
  tmpvecNorm = tmpvec/max(tmpvec); # normalize by max level tracking value
  levelTracking = c(levelTracking, tmpvec);
  levelTrackingNorm = c(levelTrackingNorm, tmpvecNorm);
};

# add to our big dataset
mriBehClean$levelTracking = levelTracking;
mriBehClean$levelTrackingNorm = levelTrackingNorm;

# create a missed gain variable
mriBehClean$pocMissedGain = mriBehClean$pocRcvdMinusNotSC;
tmp = mriBehClean$poc1type;
tmp[tmp==0] = 1; # create tmp vector, change safe type to = 1, so that the vector is just 1 and -1 for losses
mriBehClean$pocMissedGain = mriBehClean$pocMissedGain*tmp; # multiply missed gain vector by our tmp vector to make the negative loss values into positive values.


summary(indivMaxEarn); # range = 3270 - 4071; mean = 3565; median = 3506

# save the big dataset we will use for our future analyses
Output_mriBehCleanRdata=file.path(config$path$data$clean,config$Rdata$RDM_group_clean_Rdata)
save(file=Output_mriBehCleanRdata, mriBehClean);

Output_mriBehCleanCSV = file.path(config$path$data$clean, config$csvs$RDM_group_clean_csv)
write.csv(file = Output_mriBehCleanCSV, x = mriBehClean, row.names = F);
