#!/usr/bin/python


import os
from os.path import exists
import glob


analysisName='choiceDispNoMod' # change analysis name

# one thing to do is make this even more dynamic where we just define the analysis name once at the top of this script (e.g. choiceDispNoMod) and everything updates
studydir = '/data/psychology/sokol-hessnerlab/VNI' # study directory
fsfdir = '%s/scripts/fsfs/lev1/%s'%(studydir,analysisName) # where the .fsf will live

# set directory to include ALL subject runs 
subdirs = glob.glob('%s/fmriPrepOutput_ica_20.2.6/fmriprep/sub-0[0-9][0-9]/func/sub-0[0-9][0-9]_task-vni_run-[0-9]_space-MNI152NLin6Asym_desc-smoothAROMAnonaggr_bold.nii.gz'%(studydir))


# Go through all the files and make .fsf models
dir = subdirs
for dir in list(subdirs):
    splitdir = dir.split('/')  #split the file path by back slashes
    splitdir_sub = splitdir[7] # get the 8th component (7th in python) and save a subject ID ("sub-001")
    subnum = splitdir_sub[-3:] # just get the number of the subject ("001"
    splitdir_func = splitdir[9] # get the BOLD file name 
    splitfunc = splitdir_func.split('_') # split up the BOLD file name
    splitfunc_run = splitfunc[2] #get the run number, its the 3rd component (2nd in python;"run-1") 
    runnum = splitfunc_run[-1:] # just get the number of the run ("1")
    

    missTdirs='%s/timingFiles/missedTrials/sub-%s'%(studydir,subnum) # where missed trial timing file is located for participant
    missedTimingFilePath='%s/noMissedTrials_run%s.txt'%(missTdirs,runnum) # the timing file we will look for

# Check if timing file exists, if not, then participant missed a trial in this run and we will use the correct timing file. Set the convolution as well.
    if exists(missedTimingFilePath):
        print('sub-%s did not miss any trials on run %s'%(subnum, runnum))
        missTfileName='noMissedTrials_run%s.txt'%(runnum) # set timing file name
        setConv='0' # set convolution to non
    else:
        print('sub-%s missed at least one trial on run %s'%(subnum,runnum))
        missTfileName='missT_%s_run%s.txt'%(analysisName,runnum)
        setConv='3' 
    
    #print(subnum)
    replacements = {'SUBJECT':subnum, 'RUN':runnum, 'MISSTFILENAME':missTfileName, 'SETCONV':setConv}
    with open('%s/%s_template.fsf'%(fsfdir,analysisName)) as infile:
      with open('%s/sub-%s_run%s.fsf'%(fsfdir,subnum,runnum),'w') as outfile:
        for line in infile:
         for src, target in replacements.iteritems():
            line = line.replace(src, target)
         outfile.write(line)
