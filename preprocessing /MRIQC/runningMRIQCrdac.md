# Steps for running MRIQC on the RDAC using a singularity container.
Hayley Brooks 4/2/21
Sokol-Hessner Lab
University of Denver

1) log into rdac: ssh -Y first.last@rdac.du.edu
2) enter password
3) type: 
-`cd /data/psychology/sokol-hessnerlab/VNI
-	vniBIDS: VNI data in bids format
-	sourceData:  raw VNI data with COINS' M803 numbers for participants
-	MRIQCoutput: output of MRIQC
-	MRIQCsing: where the singularity image is stored 
-	work: created by MRIQC/fMRIprep to store workflow shit that I don't understand
-	mriqc_#####.log - any logs that are produced from running mriqc (usually deleted afterward)
-	sbatch_mriqc.sh: SLURM job submission script for a single participant
-	sbatch_mriqc_group.sh: SLURM job submission script for group MRIQC
	

4) This step does not need to be done again unless something happens with the singularity image or we need to update it etc. Type:
	a) cd MRIQCsing/ (now you're in the folder where the sigularity image lives)
	b) module load singularity/3.4.1 (depending on when this is happening, the singularity module may have been updated - check with Ivan if having issues here or just type singularity/ and then press tab to see which version is available).
	c) singularity pull --name mriqc_<version>.sif docker://poldracklab/mriqc:latest (this pulls the latest singularity image from the poldrack lab's docker page and gives it the name mriqc_<version>.sif. Replace <version> with the version number.)
	d) update the singularity image name in the sbatch_mriqc.sh file


5) Run the sbatch_mriqc.sh file to run MRIQC on a single participant by typing: 
-		sbatch sbatch_mriqc.sh file ### (where ### is subject number e.g., 001.)
No need to load singularity module here because its loaded by the sbatch_mriqc.sh script)

