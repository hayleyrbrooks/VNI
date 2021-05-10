# Running fMRIprep on RDAC using singularity container


## 1) log into RDAC:
		ssh -Y first.last@rdac.du.edu


## 2) change directory
		cd /data/psychology/sokol-hessnerlab/VNI/


## 3) Updated the sbatch_fmriprep_ICA.sh job submission script to specify which participants to run
		vim sbatch_fmriprep.sh
	where it says 
		SBATCH --array (specify row numbers corresponding to subject ID numbers in ids.tx). 
	for example, for the first three participants
		SBATCH --array=1-3 



## If singularity image for fMRIprep needs to be updates: 
Loading the singularity module:
	a) cd /data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/ (this is the directory where the singularity module is stored)
	b) module load singularity/3.4.1 (load singularity, version may change over time)
	c)export SINGULARITY_TMPDIR="/data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/SINGULARITY_TMPDIR"
	d) export SINGULARITY_CACHEDIR="/data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/SINGULARITY_CACHEDIR"
	e) singularity pull --name fmriprep.simg docker://poldrack/fmriprep:latest (loads the latest fmriprep module. rename fmriprep.simg to include the latest version. do not change versions during analysis of a single study)