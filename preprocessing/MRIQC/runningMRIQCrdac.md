# Steps for running MRIQC on the RDAC using a singularity container.

## 1) log into rdac: 
	ssh -Y first.last@rdac.du.edu
## 2) change directory:
	cd /data/psychology/sokol-hessnerlab/VNI/scripts
	
### VNI directory contents used for MRIQC (RDAC)
-	vniBIDS(directory): VNI data in bids format
-	sourceData(directory):  raw VNI data with COINS' M803 numbers for participants
-	MRIQCoutput(directory): output of MRIQC
-	MRIQCsing(directory): where the singularity image is stored 
-	work(directory): created by MRIQC/fMRIprep to store workflow stuff
-	scripts(directory):
	-	sbatch_mriqc.sh: SLURM job submission script for a single participant
	-	sbatch_mriqc_group.sh: SLURM job submission script for group MRIQC
	-	mriqc_#####.log: any logs that are produced from running mriqc (usually deleted afterward)

	
## 3) Run the sbatch_mriqc.sh file to run MRIQC on a single participant by typing: 
		sbatch sbatch_mriqc.sh ### 
where ### is subject number e.g., 001.
No need to load singularity module here because its loaded by the sbatch_mriqc.sh script)


## IF singularity image needs to be updated:
Go to directory where singluarity image lives, load singularity module, pull image from docker and give it the name mriqc_<version>.sif  :
	
	cd MRIQCsing/
	module load singularity/3.4.1 
	singularity pull --name mriqc_<version>.sif docker://nipreps/mriqc:latest 
	
Update the singularity image name in the sbatch_mriqc.sh file
