# Running fMRIprep on RDAC using singularity container


## 1) log into RDAC:
		ssh -Y first.last@rdac.du.edu


## 2) change directory to scripts location
		cd /data/psychology/sokol-hessnerlab/VNI/scripts/

### VNI directory contents used for fMRIprep (RDAC)
-	vniBIDS(directory): VNI data in bids format
-	sourceData(directory):  raw VNI data with COINS' M803 numbers for participants
-	fmriPrepOutput_ica(directory): output of fMRIprep output using ICA-AROMA
-	FMRIPREPsing(directory): where the singularity image is stored 
-	work(directory): created by MRIQC/fMRIprep to store workflow stuff
-	ids.txt(file): list of subject IDs
-	scripts(directory): where scripts for VNI are stored
	-	fmriprep_ica#####_##.log: logs that are produced from running fmriprep (usually deleted afterward or moved to fmripreplogs)
	-	sbatch_fmriprep_ICA.sh: SLURM job submission script

## 3) Update the sbatch_fmriprep_ICA.sh job submission script to specify which participants to run
		vim sbatch_fmriprep.sh

specify participants in the 'SBATCH --array' line:
		
		SBATCH --array (specify row numbers corresponding to subject ID numbers in ids.tx). 
for example, for the first three participants
		
		SBATCH --array=1-3 
		
## 4) Run the sbatch_fmriprep_ICA.sh file to run fMRIprep by typing: 
		sbatch sbatch_fmriprep_ICA.sh 

No need to load singularity module here because its loaded by the sbatch_fmriprep_ICA.sh script


## If singularity image for fMRIprep needs to be updated: 
Change directory to where image lives
	
	cd /data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/ 
Load singularity, version may change over time
	
	module load singularity/3.4.1 

Do some stuff following instructions on fMRIprep website and load the latest fmriprep module and rename fmriprep.simg to include latest version (don't update version during a single study)

	export SINGULARITY_TMPDIR="/data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/SINGULARITY_TMPDIR"
	export SINGULARITY_CACHEDIR="/data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/SINGULARITY_CACHEDIR"
	singularity build fmriprep-<version>.simg docker://nipreps/fmriprep:latest 
	
	
## NOTEs: 
1) As of Winter 2022, submitting a job array to the RDAC *usually* runs fine but sometimes will get caught up and processes will just hang for days and will have trouble closing out (e.g. when using scancel <jobid> ). Because of this, Ivan asked us to just submit individual job submission scripts (i.e. one for each participants). This involves commenting out the '--array=' code and making 'SUBJECT=$1'. Then when you submit the job script, the command is: 'sbatch sbatch_fmriprep_ICA.sh 001' (e.g. if we wanted to preprocesses participant 001). This is much slower and tedious to do, but it did seem to result in less issues overall.
	
2) Subject 003 output (sub-003.html) from fmriprep was showing some skull-stripping issues where a big chunk of the frontal lobe was being cut off. To deal with this, we used FSL Brain Extraction Tool to manual skull-strip and then saved the skull-stripped T1w file in vniBIDS folder for sub-003. The T1w image in sub-003's BIDS folder is *not* the original but is the skull-stripped version. The original, non-skull-stripped T1w is in separate folder on the RDAC in data/psychology/sokol-hessnerlab/VNI/sub-003_vniBIDS_noBET. This was to keep the vniBIDS directory bids-compliant. To run this participant, we used a different bash script that told fmriprep to skip skull stripping (data/psychology/sokol-hessnerlab/VNI/scripts/sbatch_fmriprep_ICA_skipBET.sh). The command is the same as the note above: "sbatch sbatch_fmriprep_ICA_skipBET.sh 003". 
