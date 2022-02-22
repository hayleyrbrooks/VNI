# Running first level analysis using FSL
- In FSL, first-level analyses involves each functional run for each participant. There is an option to run all all runs together in FSL but only if you want to do identical things to each run which doesn't work for us because each run has unique onset files.

### Overview of steps
#### 1. Generate a template design.fsf file using the FSL FEAT GUI. 
  - Start with a single participant (e.g. sub-001) and run (e.g. run 1), select all the options you want in the GUI and then click "save". This will output the model along with other files but the one we care about here is design.fsf.
  - Save the design.fsf file as "template.fsf" on RDAC ("/data/psychology/sokol-hessnerlab/VNI/scripts/fsfs
  - Created a directory for all level one .fsf files ("/data/.../scripts/fsfs/lev1/")
  - Created a python script that takes the template.fsf file and fills in all the correct information for each subject and run. Each participant/run gets a unique .fsf file (script file name = makeFSFlev1.py, located in scripts directory on RDAC). Followed this [video](https://www.youtube.com/watch?v=Js0tlNXxd9k&ab_channel=mumfordbrainstats).
  - This script inputs the correct location of onset files, confound files, output directorys, BOLD inputs, etc that FEAT needs for each participant and run.
	- right now, first level model will include gain amount, safe amounts and mean ev amounts during choice option display (starting simple). Later, we will need to update these .fsf files with more EV information (will likely need to generate a template again through GUI)
  - Run the script to create the .fsf files for each participant:
  
        -  cd /data/psychology/sokol-hessnerlab/VNI/scripts
        -  module load apps/python<press tab to complete>
        -  python makeFSFlev.py
      
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

### Scripts

### Resources
