#!/bin/bash
#SBATCH --job-name=highLevSetup           
#SBATCH --ntasks=1            
#SBATCH --cpus-per-task=4		#Ivan suggested this to speed it up     
#SBATCH --mem=50gb                    # Job memory request
#SBATCH --time=1-00:00:00              # Time limit dd-hrs:min:sec -- currently set to 1 day
#SBATCH --output=highLevSetup_%A.log    # Standard output and error log -- %j gets filled in with the job ID 
####



# Because we used fMRIprep for preprocessing, we need to set up the FEAT higher-level analyses to skip registration. We ran the bare minimum registration in the first level-analyses otherwise higher-level analyses in FSL will break. Now we will replace the files in the registration FEAT output directories.


SUBJECT=$1

# LOAD FSL
module load apps/FSL/6.0.5


# define feat output directory and fsf directory
FEATDIR=/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1
MODELTYPE=choiceDispNoMod

# check that "reg_standard" directory hans't already been created in the first-level feat directory, delete it if it has been created (this directory is only created with higher level analyses are run)

for run in 1 2 3; do
	if [ -d "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard" ]
		then
			echo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard exists. Deleting it now."
			rm -r "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard"
	else 
			echo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard does not exist."
	fi 


# Delete all the .mat files in the reg directory and replace with identity matrix
	cd ${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg # go to the reg directory
	rm *.mat # delete the .mat files (this should delete two files)

	cp $FSLDIR/etc/flirtsch/ident.mat example_func2standard.mat # the first argument is a universal fsl location for the identity matrix which we want to replace the func2standard.mat file (keeping the name example_func2standard.mat
# this ensures that data won't be moved at all

# next make sure data is not interpolated again (voxels need to line up exactly)
# overwrite the standard.nii.gz file in the current directory (reg) with the mean_func.nii.gz in the run*.feat directory
	cp ../mean_func.nii.gz standard.nii.gz

done  

