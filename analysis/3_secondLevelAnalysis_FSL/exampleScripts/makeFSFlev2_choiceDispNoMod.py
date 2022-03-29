#!/usr/bin/python


import os
import glob


studydir = '/data/psychology/sokol-hessnerlab/VNI' # study directory
fsfdir = '%s/scripts/fsfs/lev2/choiceDispNoMod'%(studydir) # where the .fsf will live

# set directory to include ALL subject runs 
subdirs = glob.glob('%s/FEAT_models_lev1/choiceDispNoMod/sub-0[0-9][0-9]'%(studydir))


# Go through all the files and make .fsf models
dir = subdirs
for dir in list(subdirs):
	splitdir = dir.split('/')  #split the file path by back slashes
	splitdir_sub = splitdir[7] # get the 8th component (7th in python) and save a subject ID ("sub-001")
	subnum = splitdir_sub[-3:] # just get the number of the subject ("001")
	subfeats = glob.glob('%s/run[0-9].feat'%(dir)) # feat directories for runs 1-3 	
   	if len(subfeats)==3:
     	  print(subnum)
     	  replacements = {'SUBJECT':subnum}
     	  with open('%s/template_lev2.fsf'%(fsfdir)) as infile:
      	    with open('%s/lev2/design_sub-%s.fsf'%(fsfdir,subnum),'w') as outfile:
	  	  for line in infile: 
	    	   for src, target in replacements.iteritems():
	      		  line = line.replace(src, target)
	    	   outfile.write(line)
