#!/usr/bin/python


import os
import glob


studydir = '/data/psychology/sokol-hessnerlab/VNI' # study directory
fsfdir = '%s/scripts/fsfs/lev1'%(studydir) # where the .fsf will live

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
    print(subnum)
    replacements = {'SUBJECT':subnum, 'RUN':runnum}
    with open('%s/choiceDispNoMod.fsf'%(fsfdir)) as infile:
      with open('%s/choiceDispNoMod/sub-%s_run%s.fsf'%(fsfdir,subnum,runnum),'w') as outfile:
        for line in infile:
         for src, target in replacements.iteritems():
            line = line.replace(src, target)
         outfile.write(line)
