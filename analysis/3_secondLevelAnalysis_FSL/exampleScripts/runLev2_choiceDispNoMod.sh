#!/bin/bash
#SBATCH --job-name=featLevel2    
#SBATCH --mail-type=ALL     
#SBATCH --mail-user=hayley.brooks@du.edu  
#SBATCH --ntasks=1            
#SBATCH --cpus-per-task=4		#Ivan suggested this to speed it up     
#SBATCH --mem=50gb                    # Job memory request
#SBATCH --time=1-00:00:00              # Time limit dd-hrs:min:sec -- currently set to 1 day
#SBATCH --output=feat_lev2_%A.log    # Standard output and error log -- %j gets filled in with the job ID
####

SUBJECT=$1
MODELTYPE=choiceDispNoMod
# define feat output directory and fsf directory
#FEATDIR=/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev2/${MODELTYPE}
FSFDIR=/data/psychology/sokol-hessnerlab/VNI/scripts/fsfs/lev2/${MODELTYPE}

# load module
module load apps/FSL/6.0.5

# do the second level analysis for each run

echo "sub-${SUBJECT} second level started"

feat ${FSFDIR}/sub-${SUBJECT}.fsf 

echo "sub-${SUBJECT} second level complete"


