#!/bin/bash

BASEDIR=/data/psychology/sokol-hessnerlab/VNI

filename=${BASEDIR}/ids.txt # locate id file where participant IDs are listed

cat ${BASEDIR}/ids.txt | while read line || [[ -n $line ]];
do

    echo "$line" # tell us the sub id number

	# Create folders for each participant 
    cd ${BASEDIR}/confoundFiles/ # go to the confoundFiles directory
    mkdir sub-${line}        # create a folder for participant

    for run in 1 2 3; do # for each run
		
    	cd ${BASEDIR}/fmriPrepOutput_ica_20.2.6/fmriprep/sub-${line}/func/  # change directories to the fmriprep output directory where confounds live

      		for reg in csf white_matter; do # for each of the confounds we are interested in, pull out the column (csf or wm) in the file and save it in its own file in our confoundFiles directory
       		awk -v col=$reg 'NR==1{for(i=1;i<=NF;i++){if($i==col){c=i;break}} print $c} NR>1{print $c}' sub-${line}_task-vni_run-${run}_desc-confounds_timeseries.tsv > ${BASEDIR}/confoundFiles/sub-${line}/sub-${line}_${reg}_run${run}.txt;
      		done

    	cd ${BASEDIR}/confoundFiles/sub-${line} # go to the confoundFiles directory again 
    	paste sub-${line}_csf_run${run}.txt sub-${line}_white_matter_run${run}.txt | awk '{print $1,$2}' > sub-${line}_run${run}_csf_wm_confounds.txt # combine confounds into one file
		sed -n '33,1608p' sub-${line}_run${run}_csf_wm_confounds.txt > sub-${line}_run${run}_csf_wm_confounds_Trimmed.txt # remove the first 33 lines (title +32 volumes)
		sed -i "1i csf white_matter" sub-${line}_run${run}_csf_wm_confounds_Trimmed.txt # add column names back
    done
done


