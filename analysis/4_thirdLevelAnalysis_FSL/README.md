# Running third level analysis using FSL
- In FSL, third-level analyses combines all functional runs across all participants
- Similar to the first-level analysis, the following steps need to be done for EACH GLM that we are interested in and it is important to name materials for each analysis accordingly. For the sake of providing an example for this document, I will refer to a simple analysis where we looked at BOLD signal during the display of choice options with no parametric modulation (i.e. we didn't consider the dollar amounts on each trial). The name for this analysis is choiceDispNoMod.

## Overview of steps
### STEP 1: Run 3rd level analysis in FEAT GUI

1. Open FSL:

		- module load apps/FSL/<version, eg. 6.0.5 >
		- fsl


2. In the GUI click on the 'FEAT fmri analysis' button
	- Change the setting to "higher-level analysis"
	- There are 4 tabs in the window that will pop up: Misc, Data, Stats, Post-Stats. 
	- The images below show the settings that will _generally_ be used for this study. 

Data Tab:load data and specify where you want the output (e.g. "/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev2/choiceDispNoMod')

![FEATThirdLevelDataTab](https://user-images.githubusercontent.com/19710394/160905055-caadbb27-8f7c-49fb-8fa0-e381f1136d46.png)

Once you click on "select cope images", click the "paste" button.

![FEATThirdLevelPasteEmpty](https://user-images.githubusercontent.com/19710394/160905362-fb008854-5ab5-46f7-898c-7f727c414062.png)

In the terminal that you used to load FSL, type:

		- ctrl+z then bg, press enter
		- cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev2/choiceDispNoMod  # this will be different depending on analysis/GLM
		- ls -d $PWD/sub-*.gfeat/cope1.feat/stats/cope1.nii.gz 	# this will list out all the subject cope files

- copy the output from the terminal
- paste into the paste box:
	
![FEATThirdLevelPasteFilled](https://user-images.githubusercontent.com/19710394/160906273-4390d6ff-a167-4163-8cba-fe81108c659a.png)


Stats Tab:

![FEATThirdLevelStatsTab](https://user-images.githubusercontent.com/19710394/160907707-a1755bf2-6e4e-4f32-9d88-bbfa65dcfbcf.png)


Setting up the model and contrasts:

![FEATThirdLevelModelSetup](https://user-images.githubusercontent.com/19710394/160906931-10ba1226-ebaf-475d-a3ac-99ef6d2592d9.png)

![FEATThirdLevelContrast](https://user-images.githubusercontent.com/19710394/160906935-137708ca-bd0a-43e9-9bab-264eb2dc4e12.png)


Post-stats Tab:

![FEATThirdLevelPostStatsTab](https://user-images.githubusercontent.com/19710394/160906979-8ebe4f30-8e9e-4b46-9c02-31e9399c9ff8.png)


Misc Tab:

![FEATThirdLevelMiscTab](https://user-images.githubusercontent.com/19710394/160906576-2e745ab3-bba3-4700-9c79-f3f53f1950f8.png)


- Once you have selected the options that you want for the GLM, click "go". This will run the third-level analysis which should only take a couple of minutes.
- exit FSL.


 - Check how FEAT model is doing:
      #### one way:
          -  cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev3/nameOfModel.gfeat
          -  firefox report.log
      - this will open the FEAT log report and will give you more details including if it is still running, if an error ocurred, and any output generated so far.

### STEP 2: QA 
- check the masks, that parts werent left out
	- load the mask (mask.nii.gz) and the background image (bg_image.nii.gz; this is everyone's functional after registration averaged together)
	- put mask on top and scroll through the images to see if any part of the mask is missing
- check log and html output (for any errors, etc)
- flip through cope1.feat/filter_func_data.nii.gz (it is one file and each volume is a participant - looking for super dark or light)
- important results are the thresh_zstat image (in cope#.feat directory), can put over bg_image to see group activation

## Some resources
1. Mumford Brain Stats [youtube](https://www.youtube.com/watch?v=49WGLPZNTrQ&ab_channel=mumfordbrainstats)
2. And this[video](https://www.youtube.com/watch?v=nyajZKJ-uwk&ab_channel=mumfordbrainstats)
3. Andy's Brain [Book](https://andysbrainbook.readthedocs.io/en/latest/fMRI_Short_Course/fMRI_08_3rdLevelAnalysis.html)
