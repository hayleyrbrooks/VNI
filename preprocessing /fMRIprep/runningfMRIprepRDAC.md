# Running fMRIprep on RDAC using singularity container


## 1) log into RDAC:
		ssh -Y first.last@rdac.du.edu


## 2) change directory
		cd /data/psychology/sokol-hessnerlab/VNI/

### VNI directory contents used for fMRIprep (RDAC)
-	vniBIDS: VNI data in bids format
-	sourceData:  raw VNI data with COINS' M803 numbers for participants
-	fmriPrepOutput_ica: output of fMRIprep output using ICA-AROMA
-	FMRIPREPsing: where the singularity image is stored 
-	work: created by MRIQC/fMRIprep to store workflow stuff
-	fmriprep_ica#####_##.log: logs that are produced from running fmriprep (usually deleted afterward or moved to fmripreplogs)
-	sbatch_fmriprep_ICA.sh: SLURM job submission script

## 3) Updated the sbatch_fmriprep_ICA.sh job submission script to specify which participants to run
		vim sbatch_fmriprep.sh

specify participants 
		
		SBATCH --array (specify row numbers corresponding to subject ID numbers in ids.tx). 
for example, for the first three participants
		
		SBATCH --array=1-3 



## If singularity image for fMRIprep needs to be updates: 
Change directory to where image lives
	
	cd /data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/ 
Load singularity, version may change over time
	
	module load singularity/3.4.1 

Do some stuff following instructions on fMRIprep website and load the latest fmriprep module and rename fmriprep.simg to include latest version (don't update version during a single study)

	export SINGULARITY_TMPDIR="/data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/SINGULARITY_TMPDIR"
	export SINGULARITY_CACHEDIR="/data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/SINGULARITY_CACHEDIR"
	singularity pull --name fmriprep.simg docker://poldrack/fmriprep:latest 
	
	
