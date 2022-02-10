For this study, we used fMRIprep version 20.2.6

For a single participant, it takes about 40 hours to complete fmriprep (ICA-AROMA adds a significant amount of time).
To check the output:
1) We reviewed the .html files for any issues with skull-stripping, etc and checked for errors (this is where we caught the weird skull-stripping with sub-003)
2) We briefly looked at the anat and functional runs (e.g. ~_desc-smoothAROMAnonaggr_bold.nii.gz) for any issues using FSLeyes (movie mode - make sure to deselect "synchronize movie updates" in the control settings box.



## NOTES:
- functional output (e.g. ~_desc-smoothAROMAnonaggr_bold.nii.gz) is not preprocessed for the first 32 volumes (because these are the dummy scans that we will delete) but fmriprep doesn't delete these, it just doesn't preprocess them.


