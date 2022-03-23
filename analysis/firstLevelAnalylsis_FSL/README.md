# Running first level analysis using FSL
- In FSL, first-level analyses involves each functional run for each participant. There is an option to run all all runs together in FSL but only if you want to do identical things to each run which doesn't work for us because each run has unique onset files.
- The following steps need to be done for EACH analysis (i.e. GLM) that we are interested in and it is important to name materials for each analysis accordingly. For the sake of providing an example for this document, I will refer to a simple analysis where we looked at BOLD signal during the display of choice options with no parametric modulation (i.e. we didn't consider the dollar amounts on each trial). The name used throughoutthis analysis is choiceDispNoMod.

## Overview of steps
### STEP 1: Generate a first-level analysis template file (.fsf) using the FSL FEAT GUI starting with a single participant (e.g. sub-001) and run (e.g. run 1).
- We use the GUI to generate a design.fsf template for a single participant and run, then we take that design template and use a script to dynamically update the template for each participant and each run. Otherwise, you have to use the GUI to set up the first-level analysis for each participant/run and that is *really* not recommended (seriously, please don't do this).
1. Load FSL on the RDAC using terminal
	
		- module load apps/FSL/<version, eg. 6.0.5 >
		- fsl
2. In the GUI click on the 'FEAT fmri analysis' button
	- There are 6 tabs in the window that will pop up: Misc, Data, Registration, Pre-stats, Stats, Post-Stats. 
	- The images below show the settings that will _generally_ be used for this study. The settings that will change will happen under the Stats tab since that is where we load the onset files which will vary depending on our GLM.
	- *Note* that because we already preprocessed the data with fMRIprep, we don't need to do any additional preprocessing in FSL. However, we can't skip registration at the first-level because this will "break" higher-level FSL analyses. See how we set the settings in the image below (as recommended by Jeneatte Mumford [here](https://mumfordbrainstats.tumblr.com/post/166054797696/feat-registration-workaround)). We then have to do a couple of things *after* the first-level analyses to work out this (which we will wory about later).


Data Tab:

![FEATfirstLevDataTab](https://user-images.githubusercontent.com/19710394/159761573-1cf711e8-b989-4210-a492-3249d1cf696f.png)

Prestats Tab:

![FEATfirstLevPrestatsTab](https://user-images.githubusercontent.com/19710394/159762061-1067637c-df75-4ddc-b2d4-1ccf5f091a5b.png)

Registration Tab:

![FEATfirstLevRegTab](https://user-images.githubusercontent.com/19710394/159762338-4f5b7b16-adee-4cbe-be1f-78e5858b713f.png)

Stats Tab:

![FEATfirstLevStatsTab](https://user-images.githubusercontent.com/19710394/159762715-3d1bb46d-785d-4fb8-9940-131eda054bec.png)

Model Setup (loading timing files and setting up contrasts):

![FEATfirstLevFullModelSetup](https://user-images.githubusercontent.com/19710394/159763799-71dba592-1844-47c6-b47a-1116ed39e40b.png)

![FEATfirstLevContrast](https://user-images.githubusercontent.com/19710394/159763836-b8ec31d5-7497-49aa-b01a-cb78ef194090.png)


Post-stats Tab:

![FEATfirstLevPostStatsTab](https://user-images.githubusercontent.com/19710394/159764078-3a90689d-92f3-40f9-9f46-28c1bdb4b9da.png)


Misc Tab:

![FEATfirstLevMiscTab](https://user-images.githubusercontent.com/19710394/159760333-4cbffbf3-e380-4b93-9f04-a7e84afd3f03.png)


- Once you have selected the options that you want for a given GLM, click "save". This will output the .fsf file along with other first-level model files that you can delete. Make sure that the template .fsf file is named for the analysis of interest (e.g. "choiceDispNoMod.fsf") on RDAC ("/data/psychology/sokol-hessnerlab/VNI/scripts/fsfs/lev1")
- Then click "Exit". This will exit the FEAT window without running the model. 

### STEP 2: Make the .fsf files for each participant and each run (using our template .fsf file, e.g. choiceDispNoMod.fsf)
  - Open the template .fsf file. We want to replace the subject number (e.g.  '001') with SUBJECT and run numbers (e.g. "1") with RUN. These are the replacement words that the python script below will look for to replace with the correct subject ID and run number.
  - Create a directory for all level one .fsf files for a given analysis ("/data/.../scripts/fsfs/lev1/choiceDispNoMod")
  - Use the python script that takes the template .fsf file and fills in all the correct information for each subject and run. Each participant/run gets a unique .fsf file (script file name = makeFSFlev1_choiceDispNoMod.py, located in scripts directory on RDAC). I followed this [video](https://www.youtube.com/watch?v=Js0tlNXxd9k&ab_channel=mumfordbrainstats) to create this script. For each analysis, this script will need to be updated (by copying it, renaming it to match the appropriate analysis, and then making minor revisions to the correct file locations/names). Depending on the GLM, this python script may need more complex revisions (e.g. if we need to add more onset files).
  - This script inputs the correct location of onset files, confound files, output directorys, BOLD inputs, etc that FEAT needs for each participant and run.
  - Run the script to create the .fsf files for each participant:
  
        -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/firstLevel
        -  module load apps/python<press tab to complete>
        -  python makeFSFlev1_choiceDispNoMod.py

 - Now there should be .fsf file for each participant and run in "/data/psychologyscripts/fsfs/lev1/choiceDispNoMod/"
      
### STEP 3: Do the first-level analysis
There are four different scripts for this:
1. runLev1_nameOfModel.sh (e.g. runLev1_choiceDispNoMod.sh) 
2. runLev1_run1_nameOfModel.sh (e.g. runLev1_run1_choiceDispNoMod.sh)
3. runLev1_run2_nameOfModel.sh (e.g. runLev1_run2_choiceDispNoMod.sh)
4. runLev1_run3_nameOfModel.sh (e.g. runLev1_run3_choiceDispNoMod.sh)

The first model runs all three runs in parallel for a single participant and the others run a single run (this is necessary for when a single run crashes, which unfortunately happens often on the RDAC).

Running each script is very similar:

         -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/firstLevel
         -  sbatch runLev1_nameOfModel.sh <three digit ID number, e.g. 001> (to run all runs)
	  
	To run a single run:
	  -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/firstLevel
	  -  sbatch runLev1_run1_nameOfModel.sh <001> 
	  
 - Output is saved in the directory that is specified in the .fsf files
 - Check how FEAT model is doing:
      #### one way:
          -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/
          -  cat feat_lev1_<jobID#>_<run#>.log (e.g. feat_lev1_260132_1.log)
      - this will tell you which run is being processed and which runs are complete (but it won't always tell you if there was an error)
      #### another way:
          -   firefox /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/sub-*/run*.feat/report_log.html
      - this will open the FEAT log report and will give you more details including if it is still running and if an error ocurred

### STEP 4: QA 
1) Check that the following files exists for each participant: 
	- zstat file for each contrast
	- cope file for each contrast
	- varcope file for each contrast

      		- cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/<nameofmodel>
      		- ls sub-*/run*.feat/stats/zstat*.nii.gz (this will print the existing zstat files for all the runs and participants)
      		- add | wc -l to check the file count (faster if you know that each participants has 3 runs, the output should be 3 x Nsub x contrast)

2) Check that there are not errors in the logs (open report for all runs for a single participant): 

          -   firefox /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/sub-001/run*.feat/report_log.html
	
	
3) Check that models are good and check for collinearity using QA_all_levs1.py in the scripts/firstLevel directory (this script will need to be updated for each GLM). 

          -   chmod +x QA_all_levs1.py
          -   ./QA_all_levs1.py
	
- This combines the models for each participant and run into a single html file that is stored in the FEAT_models_lev1 directory (lev1_QA.html)
- ignoring registration because we already did that fmriprep


## Scripts
- These scripts are for examples purposes (using the model with choice display and no modulation). The rest of the scripts live on the RDAC and are updated to reflect each model/GLM.
1. makeFSFlev1_choiceDispNoMod.py
2. runLev1_choiceDispNoMod.sh
3. runLev1_run1_choiceDispNoMod.sh
4. runLev1_run2_choiceDispNoMod.sh
5. runLev1_run3_choiceDispNoMod.sh
6. QA_all_levs1.py

## Some resources
1. Mumford Brain Stats [youtube](https://www.youtube.com/channel/UCZ7gF0zm35FwrFpDND6DWeA)
2. Mumford Brain Stats [blog](https://mumfordbrainstats.tumblr.com/post/166054797696/feat-registration-workaround)
