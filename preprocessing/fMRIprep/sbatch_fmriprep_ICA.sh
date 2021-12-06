#!/bin/bash
#SBATCH --job-name=fmriprep_ica-1    
#SBATCH --mail-type=ALL     
#SBATCH --mail-user=hayley.brooks@du.edu  
#SBATCH --ntasks=1
#SBATCH --nodelist=node[0##]              # Specify node e.g. 003 and use 003-011 since these are not bought by others on RDAC
#SBATCH --cpus-per-task=1     
#SBATCH --mem=70gb                        # Job memory request
#SBATCH --time=14-00:00:00                # Time limit dd-hrs:min:sec
#SBATCH --output=fmriprep_ica%A_%a.log    # Standard output and error log -- %A for parent array and %a for sub array 
#SBATCH --array=19-21 # specify which rows we want this script to look for in ids.txt. 

# Can only do a few participants a time ^^ because we can't spread fmriprep across nodes (which would speed it up) because we run into a reproducibility issue. 
# So we are allocating these jobs to one node (specified above). One option would be to submit this script and then change the array specifications and run the script again
# but need to be mindful of how many jobs are submitted on RDAC at once. HRB has tried doing it this way and ran like 20 participants at once and they all got hung up.
 

# change directory to VNI head directory
cd ../

SUBJECT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ids.txt)

# Load modules below
module purge 
module load singularity/3.4.1


# Execute commands for application below
singularity run --cleanenv -B vniBIDS/:/data1:ro -B /data/psychology/sokol-hessnerlab/VNI/fmriPrepOutput_ica_20.2.6/:/out \
 /data/psychology/sokol-hessnerlab/VNI/FMRIPREPsing/fmriprep-20.2.6.simg \
 --participant_label $SUBJECT \
 -v \
 --dummy-scans 32 \
 --use-aroma --aroma-melodic-dimensionality -100 \
 --fs-license-file /data/psychology/sokol-hessnerlab/VNI/FSlicense/license.txt \
 --nthreads 1 --omp-nthreads 1 \
 -w /data/psychology/sokol-hessnerlab/VNI/work2 \
 /data1 /out participant

