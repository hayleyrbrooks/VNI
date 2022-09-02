#!/bin/bash


module load apps/FSL/6.0.5

# define feat output directory and fsf directory
FEATDIR=/data/psychology/sokol-hessnerlab/VNI/FEAT_models_lev1
MODELTYPE=decisionPOCAmt

SUBJECT=$1

for run in 1 2 3; do

	# contrast 1
	echo "voxel intensities for cope1 for run${run} should be the same:"
	fslstats "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard/stats/cope1.nii.gz" -r
	fslstats "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/stats/cope1.nii.gz" -r

	echo "data dimension and pixel size of cope file(s) should be the same as mean_func:"
	echo "data dimensions run${run}.feat/mean_func.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/mean_func.nii.gz"

	echo "data dimensions run${run}.feat/stats/cope1.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/stats/cope1.nii.gz"

	echo "data dimensions run${run}.feat/reg_standard/stats/cope1.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard/stats/cope1.nii.gz"

	echo "data dimensions run${run}.feat/reg_standard/mean_func.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard/mean_func.nii.gz"

	# contrast 2
	echo "voxel intensities for cope2 for run${run} should be the same:"
	fslstats "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard/stats/cope2.nii.gz" -r
	fslstats "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/stats/cope2.nii.gz" -r

	echo "data dimension and pixel size of cope file(s) should be the same as mean_func:"
	echo "data dimensions run${run}.feat/mean_func.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/mean_func.nii.gz"

	echo "data dimensions run${run}.feat/stats/cope2.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/stats/cope2.nii.gz"

	echo "data dimensions run${run}.feat/reg_standard/mean_func.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard/mean_func.nii.gz"

	echo "data dimensions run${run}.feat/reg_standard/stats/cope2.nii.gz:"
	fslinfo "${FEATDIR}/${MODELTYPE}/sub-${SUBJECT}/run${run}.feat/reg_standard/stats/cope2.nii.gz"

 
done
