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
	singularity pull --name fmriprep-<version>.simg docker://nipreps/fmriprep:latest 
	
	
