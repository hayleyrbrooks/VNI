# Running second level analysis using FSL
- In FSL, second-level analyses combines all functional runs for each participant. 
- Similar to the first-level analysis, the following steps need to be done for EACH GLM that we are interested in and it is important to name materials for each analysis accordingly. For the sake of providing an example for this document, I will refer to a simple analysis where we looked at BOLD signal during the display of choice options with no parametric modulation (i.e. we didn't consider the dollar amounts on each trial). The name for this analysis is choiceDispNoMod.

## Overview of steps
### STEP 1: Prep the directories from first-level analyses for second-level (using highLevelSetUp.sh script)
- When we ran the first-level analysis, we did the bare minimum registration even though we've already done registration with fMRIprep preprocessing. We ran registration because FSL breaks at higher-levels if you don't. Now we need to replace a couple of files in the "reg" directory for each participant's run so that the data doesn't get moved or interpolated again.
- As of now, the script (highLevelSetUp.sh) needs to be slightly changed for each analysis (GLM) to specify the model name (E.g. "choiceDispNoMod") so that the script knows where the first-level output directories are located. You can do this using Vim or other text editors. Save a version of this script with the name of the model you are running (e.g., highLevelSetUp_choiceDispNoMod.sh).
- This script replaces the 'example_func2standard.mat' with an identity matrix from FSL and overwrites 'standard.nii.gz' file with 'mean_func.nii.gz' while keeping those file names the same since those are what FSL will look for. This process follows the steps by Jeneatte Mumford [here](https://mumfordbrainstats.tumblr.com/post/166054797696/feat-registration-workaround).

1. Update script to reflect model you are running

		- cd /data/psychology/sokol-hessnerlab/VNI/scripts/secondLevel
		- cp highLevelSetUp.sh highLevelSetUp_choiceDispNoMod.sh 	# this copies the original script with a new name 
		- vim highLevelSetUp_choiceDispNoMod.sh 	# open the script using VIM (or some other text editor)
		## Once vim opens the file: 
		# 1) press "i" so that you can revise the document 
		# 2) scroll down to where the variable 'MODELTYPE' is defined
		# 3) change the name to reflect the analysis you are running (ideally the same as the modifier you added to the name of this script, e.g., 'choiceDispNoMod')
		# 4) press the escape key, then type:
		- :wq 		# this save the changes you made and exits the script.

2. Run the highLevelSetUp_nameOfModel.sh for each participant

		- sbatch highLeveLSetUp_choiceDispNoMod.sh 001  # 001 is for sub-001
		## logs for this output are in the ../scripts/secondLevel/ directory on the RDAC. 

3. Check that things look right (let's look at sub-001 and first run - changes took place in the reg directory):

		- cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/choiceDispNoMod/sub-001/run1.feat/reg  # replace 'choiceDispNoMod' with correct directory
		- ls  ## expected output show below in image

	![Screen Shot 2022-03-29 at 11 59 30 AM](https://user-images.githubusercontent.com/19710394/160676008-6bbce2ce-c87b-40b5-8ff0-56ca0f3c00ef.png)
	
	You can also use 'cat' to see what the example_func2standard.mat looks like:
	
		- cat example_func2standard.mat 
		## expected output below in image
		
	![Screen Shot 2022-03-29 at 12 04 54 PM](https://user-images.githubusercontent.com/19710394/160676483-ce6e4b36-dbcb-4359-aaef-39433298868c.png)

	To see that the standard.nii.gz was overwritten by the participant's mean_func.nii.gz, you can check that these are the same files (without using FSLeyes):
	
		# assuming you're still in the reg folder:
		
		- module load apps/FSL/6.0.5
		- fslinfo standard.nii.gz
		- fslinfo ../mean_func.nii.gz
		## These output should be identical
		
		- fslstats standard.nii.gz -r
		- fslstats ../mean_func.nii.gz -r
		## The voxel intensities should be identical

### STEP 2: Create .fsf files for each participant's second level analysis
- Similar to the first-level, we use the GUI to generate a design.fsf template for each participant, then we take that design template and use a script to dynamically update the template for each participant. Otherwise, you have to use the GUI to set up the second-level analysis for each participant and that is *really* not recommended (seriously, please don't do this).

1. Create the directory where the .fsf files will live on the rdac
- Base directory already exists: '/data/psychology/sokol-hessnerlab/VNI/scipts/fsfs/lev2'
- create the directory for the .fsf for a given analysis

		- cd /data/psychology/sokol-hessnerlab/VNI/scripts/fsfs/lev2
		- mkdir choiceDispNoMod  # replace with appropriate model name
		
2. Load FSL on the RDAC using terminal if it isn't already:
	
		- module load apps/FSL/<version, eg. 6.0.5 >
		- fsl
		
3. In the GUI click on the 'FEAT fmri analysis' button
	- Change the setting to "higher-level analysis"
	- There are 4 tabs in the window that will pop up: Misc, Data, Stats, Post-Stats. 
	- The images below show the settings that will _generally_ be used for this study. The settings that will change will happen under the Stats tab since that is where we load the onset files which will vary depending on our GLM.


Data Tab:

![featSecLev_DataTab](https://user-images.githubusercontent.com/19710394/160682747-08125b48-a782-4d2d-9eba-224a0907b4a6.png)


Stats Tab:

![featSecLev_StatsTab](https://user-images.githubusercontent.com/19710394/160682946-a4ecb6fd-0e0e-45d0-a504-5d7974abbda5.png)

**Notes about stats tab for 2nd level analysis** 
- Fixed effects of 2nd level - assuming no variance between runs for each subject  (this was recommnded [by J Mumford](https://www.youtube.com/watch?v=ssFHvOPIyDg), also used by [Andy's brain book](https://andysbrainbook.readthedocs.io/en/latest/fMRI_Short_Course/fMRI_07_2ndLevelAnalysis.html)- this is recommended when you have 2-3 runs per participant. the variance we ignore gets reintroduced at the 3rd level between participants)
- fixed effects right now but FLAME for first level: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FEAT/UserGuide
- 3rd level - dont use fixed effects. We'll want to use FLAME 1 or OLS with FLAME being the best

Model Setup (not loading any timing files at this level):


![featSecLev_fullModelSetup](https://user-images.githubusercontent.com/19710394/160683149-58d1e6be-85a6-4115-a973-a2975535d96e.png)


![featSecLev_constrasts](https://user-images.githubusercontent.com/19710394/160683168-0d3c7828-383a-457a-998c-498f54784da6.png)


Not changing anything on the Post-stats and Misc tabs

- Once you have selected the options that you want for a given GLM, click "save". This will output the .fsf file along with other first-level model files that you can delete. Make sure that the template .fsf file is named for the analysis of interest (e.g. "choiceDispNoMod.fsf") on RDAC ("/data/psychology/sokol-hessnerlab/VNI/scripts/fsfs/lev2/choiceDispNoMod.fsf")
- Then click "Exit". This will exit the FEAT window without running the model. 


### STEP 3: Make the .fsf files for each participant and each run (using our template .fsf file, e.g. choiceDispNoMod.fsf)
  - Open the template .fsf file. We want to replace the subject number (e.g.  '001') with SUBJECT. These are the replacement words that the python script below will look for to replace with the correct subject ID and run number.
  - Create a directory for all level two .fsf files for a given analysis ("/data/.../scripts/fsfs/lev2/choiceDispNoMod")
  - Use the python script that takes the template .fsf file and fills in all the correct information for each subject and run. Each participant/run gets a unique .fsf file (script file name = makeFSFlev2_choiceDispNoMod.py, located in scripts directory on RDAC). I followed this [video](https://www.youtube.com/watch?v=Js0tlNXxd9k&ab_channel=mumfordbrainstats) to create this script. For each analysis, this script will need to be updated (by copying it, renaming it to match the appropriate analysis, and then making minor revisions to the correct file locations/names). This step is similar to the copying, renaming and editing the highLevelSetUp.sh script above, so I won't write it out again here. 
  - This makeFSFlev2.py script inputs the correct location of each subject's lower level feat directories and sets the new output directory in a .fsf for each participant.
  - Run the script to create the .fsf files for each participant:
  
        -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/secondLevel
        -  module load apps/python<press tab to complete>
        -  python makeFSFlev2_choiceDispNoMod.py

 - Now there should be .fsf file for each participant and run in "/data/psychologyscripts/fsfs/lev1/choiceDispNoMod/"
      
### STEP 4: Make a copy of and necessary changes to the script that runs the second level analysis:
In the scripts/secondLevel directory, make a copy of the runLev2.sh script and add modifying name for the analysis(GLM):

	-  cd /data/psychology/sokol-hessnerlab/VNI/scripts/secondLevel  # change directory if not already there
	-  cp runLev2.sh runLev2_choiceDispNoMod.sh   # makes a copy with a new name
	-  vim runLev2_choiceDispNoMod.sh # open in vim and follow instructions in step 1 where we changed the MODELTYPE variable to be the directory where the correct fsf files live for the analysis we are interested in (for this example, its choiceDispNoMod)

### STEP 5: Run the second-level analysis (this takes ~1 min per participant)

         -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/secondLevel
         -  sbatch runLev2_nameOfModel.sh <three digit ID number, e.g. 001> 
	  
	  
 - Output is saved in the directory that is specified in the .fsf files (e.g. ../VNI/FEAT_models_lev2/choiceDispNoMod/)


 - Check how FEAT model is doing:
      #### one way:
          -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/secondLevel
          -  cat feat_lev2_<jobID#>_<run#>.log (e.g. feat_lev2_260132.log)
      #### another way:
          -   cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev2/choiceDispNoMod/sub-001.gfeat  (go to subject's folder)
          -   firefox report.log
      - this will open the FEAT log report and will give you more details including if it is still running, if an error ocurred, and any output generated so far.

### STEP 6: QA 
The first two steps are because we changed some of the feat input to skip registration since we used fMRIprep.
1) check voxel intensities between level 1 stats/cope#.nii.gz and 2nd level reg_standard/stats/cope#.nii.gz (which is actually put in the first-level analysis directory) should be exactly the same. Not with roundoff error, but exact. This ensures there was no extra smoothing to the data
		
		- fslstats <copefilename> -r  # make sure fsl is loaded, do this command for both cope files
		
		For example:
		- cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/choiceDispNoMod/sub-001/run1.feat
		- fslstats stats/cope1.nii.gz -r
		- fslstats reg_standard/stats/cope1.nii.gz -r
		# the two values for each command should be identical - no roundoff error!

		
2) data dimension and pixel size of cope file(s) should be the same as mean_func (use fslinfo)

		# assuming you're in a subject's run directory 
		- fslinfo mean_func.nii.gz
		- fslinfo stats/cope1.nii.gz
		- fslinfo reg_standard/stats/cope1.nii.gz
		- fslinfo reg_standard/mean_func.nii.gz
		
3) In each lev 2 sub directory are cope*.feat files, one for each of the lower level contrasts (e.g. 1 cope for choice disp or 3 cope files for gain, safe, and mean ev contrasts from level 1)
- in each of those cope directories there is filtered_func_data (located: 'FEAT_models_lev1/choiceDispNoMod/sub-001.gfeat/cope1.feat/'). check that, its the dependent variable (e.g. choice display or gain display depending on analysis). If its bad, the whole brain will be really dark or really light. This may be more important at the 3rd level analysis to look at everyone's (perhaps less so at this stage).

		- module load apps/FSL/6.0.5
		- cd ~/FEAT_models_lev1/choiceDispNoMod/sub-001.gfeat/cope1.feat/
		- fsleyes filtered_func_data.nii.gz
		
- once the image is loaded in FSL, use the volumn button to switch between the runs		

4) check output with QA_all_lev2s_nameOfModel.py 
- Sum of all input masks after transformation to standard space --> you want these all to show yellow brains. orange or red means one of the runs didn't have data for the brain and you won't get statistics for the missing voxels.
- Unique missing-mask voxels --> you dont want any colors over the brain, just along the edges

		 - cd /data/psychology/sokol-hessnerlab/VNI/scripts/secondLevel
		 - cp QA_all_lev2s.py QA_all_lev2s_choiceDispNoMod.py   # making a copy for the choice display analysis
		 - vim QA_all_lev2s_choiceDispNoMod.py 	# open in a text editor (I am using Vim) and revise directory names for the appropriate analysis, save.
         	 -   chmod +x QA_all_lev2s_choiceDispNoMod.py
         	 -   ./QA_all_lev2s_choiceDispNoMod.py
				

## Scripts
- These scripts are for examples purposes (using the model with choice display and no modulation). The rest of the scripts live on the RDAC and are updated to reflect each model/GLM.
1. [highLevelSetUp_choiceDispNoMod.sh](./exampleScripts/highLevelSetUp_choiceDispNoMod.sh)
2. [makeFSFlev2_choiceDispNoMod.py](./exampleScripts/makeFSFlev2_choiceDispNoMod.py)
3. [runLev2_choiceDispNoMod.sh](./exampleScripts/runLev2_choiceDispNoMod.sh)
4. [QA_all_lev2s.py](./exampleScripts/QA_all_lev2s.py)

## Some resources
1. Mumford Brain Stats [youtube](https://www.youtube.com/channel/UCZ7gF0zm35FwrFpDND6DWeA)
2. Mumford Brain Stats [blog](https://mumfordbrainstats.tumblr.com/post/166054797696/feat-registration-workaround)
