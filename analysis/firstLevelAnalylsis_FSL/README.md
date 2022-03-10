# Running first level analysis using FSL
- In FSL, first-level analyses involves each functional run for each participant. There is an option to run all all runs together in FSL but only if you want to do identical things to each run which doesn't work for us because each run has unique onset files.

### Overview of steps
#### 1. Generate a template design.fsf file using the FSL FEAT GUI. 
  - Start with a single participant (e.g. sub-001) and run (e.g. run 1), select all the options you want in the GUI and then click "save". This will output the model along with other files but the one we care about here is design.fsf.
  - Save the design.fsf file as a template named for the analysis "choiceDispNoMod.fsf" on RDAC ("/data/psychology/sokol-hessnerlab/VNI/scripts/fsfs/lev1")
  - In the template fsf file, replaced subject numbers (e.g.  '001') with SUBJECT and run numbers (e.g. "1") with RUN. These are the replacement words that the python script below will look for to replace with the correct subject ID and run number.
  - Created a directory for all level one .fsf files for a given analysis ("/data/.../scripts/fsfs/lev1/choiceDispNoMod")
  - Created a python script that takes the template.fsf file and fills in all the correct information for each subject and run. Each participant/run gets a unique .fsf file (script file name = makeFSFlev1_choiceDispNoMod.py, located in scripts directory on RDAC). Followed this [video](https://www.youtube.com/watch?v=Js0tlNXxd9k&ab_channel=mumfordbrainstats).
  - This script inputs the correct location of onset files, confound files, output directorys, BOLD inputs, etc that FEAT needs for each participant and run.
	- right now, first level model will include gain amount, safe amounts and mean ev amounts during choice option display (starting simple). Later, we will need to update these .fsf files with more EV information (will likely need to generate a template again through GUI)
  - Run the script to create the .fsf files for each participant:
  
        -  cd /data/psychology/sokol-hessnerlab/VNI/scripts
        -  module load apps/python<press tab to complete>
        -  python makeFSFlev1_choiceDispNoMod.py
      
#### 2. Do the first-level analysis
  - Created runFirstLevel.sh script to run feat for a single participant and each of their runs in parallel:
  
          -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/
          -  sbatch runFirstLevel.sh <three digit ID number, e.g. 001>

  - Sometimes only a single run will mess up and need to be rerun. There are three scripts that take care of that: runFirstLevel_run1.sh, runFirstLevel_run2.sh, runFirstLevel_run3.sh.

          - sbatch runFirstLevel_run1.sh <three digit ID number, e.g. 001>

  - Output is saved in the directory that is specified in the .fsf files
  - Check how FEAT model is doing:
      #### one way:
          -  cd /data/psychology/sokol-hessnerlab/VNI/scripts/
          -  cat feat_lev1_<jobID#>_<run#>.log (e.g. feat_lev1_260132_1.log)
      - this will tell you which run is being processed and which runs are complete (but it won't always tell you if there was an error)
      #### another way:
          -   firefox /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/sub-###/run#.feat/report_log.html
      - this will open the FEAT log report and will give you more details including if it is still running and if an error ocurred

#### 3. QA 
1) Check that the following files exists for each participant: 
	- zstat file for each contrast
	- cope file for each contrast
	- varcope file for each contrast

      		- cd /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/
      		- ls sub-*/run*.feat/stats/zstat*.nii.gz (this will print the existing zstat files for all the runs and participants)
      		- add | wc -l to check the file count (faster if you know that each participants has 3 runs, the output should be 3 x Nsub x contrast)
2) Check that there are not errors in the logs 
	- in x2go terminal: firefox /data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/sub-001/run*.feat/report_log.html (this will open all the reports at once for a single participant)
3) Check that models are good and check for collinearity. CD to scripts directory
	- chmod +x QA_all_levs1.py
	- ./QA_all_levs1.py
	- This combines the models for each participant and run into a single html file that is stored in the FEAT_models_lev1 directory (lev1_QA.html)
	- ignoring registration because we already did that fmriprep


### Scripts
1. makeFSFlev1.py
2. runFirstLevel.sh
3. runFirstLevel_run1.sh
4. runFirstLevel_run2.sh
5. runFirstLevel_run3.sh
6. QA_all_levs1.py

### Resources
1. Mumford Brain Stats [youtube](https://www.youtube.com/channel/UCZ7gF0zm35FwrFpDND6DWeA)
2. Mumford Brain Stats [blog](https://mumfordbrainstats.tumblr.com/post/166054797696/feat-registration-workaround)
