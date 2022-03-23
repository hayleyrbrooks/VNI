#!/bin/bash
#SBATCH --job-name=featLevel1    
#SBATCH --mail-type=ALL     
#SBATCH --mail-user=hayley.brooks@du.edu  
#SBATCH --ntasks=1            
#SBATCH --cpus-per-task=4     
#SBATCH --mem=50gb                    # Job memory request
#SBATCH --time=1-00:00:00              # Time limit dd-hrs:min:sec -- currently set to 1 day
#SBATCH --output=feat_lev1_run2_%j.log    # Standard output and error log -- %j gets filled in with the job ID  			
####

SUBJECT=$1

# define feat output directory and fsf directory
FEATDIR=/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1/choiceDispNoMod
FSFDIR=/data/psychology/sokol-hessnerlab/VNI/scripts/fsfs/lev1/choiceDispNoMod

# load module
module load apps/FSL/6.0.5

#check whether sub directory exists and if not, make it for feat output
if [ -d "${FEATDIR}/sub-${SUBJECT}" ]
then
	echo "Directory ${FEATDIR}/sub-${SUBJECT} exists."
else 
	mkdir ${FEATDIR}/sub-${SUBJECT}
	echo "FEAT directory made for sub-${SUBJECT}."
fi 

runs=2 

# do the first level analysis
echo "run ${runs} for sub-${SUBJECT} first level started"

feat ${FSFDIR}/sub-${SUBJECT}_run${runs}.fsf 

echo "run ${runs} for sub-${SUBJECT} first level complete"


