# Value in Context Neuroimaging study 

#### This repository contains the preprocessing and analysis scripts for this project. Data and task scripts are on the SHLAB S drive under the VNI project directory

## 1) [Preprocessing](./preprocessing)
  - Spreadsheet of the visual quality control notes 
### [MRIQC](./preprocessing/MRIQC)
  - Group T1w and BOLD reports (html and tsv) with image quality metrics (IQM)
  - MRIQC report key (brief descriptions of IQM)
  - MRIQC summary of results
  - Instructions for running MRIQC using singularity container on RDAC
### [fMRIPrep](./preprocessing/fMRIprep)
  - Instructions for running fMRIprep using singularity container on RDAC
  - Bash script for running fMRIprep on this dataset
  - CITATION.md provided by fMRIprep for describing fMRIprep in manuscript
### [Timing files](./preprocessing/timingFilesSetup)
  - Script for creating event files (Matlab)
  - Script for creating onset/timing file for FSL(R)
## 2) [Analysis](./analysis)
### [Behavior](./analysis/mriBehaviorAnalysis)

#### [code](./analysis/mriBehaviorAnalysis/code)
  - Clearning risky decision-making (RDM) data script
  - Quality analysis of RDM script
  - RDM analysis (glmer) script
#### [documentation](./analysis/mriBehaviorAnalysis/documentation)
  - Quality analysis document
  - RDM analysis document
#### [figures](./analysis/mriBehaviorAnalysis/figures)
  - output from analysis scripts
### fMRI (BOLD) - not created yet

## 3) [Task Design](./taskDesign)
  - Design parameters document for the risky decision making choice set
  - script that generates figures for design parameters document
  - figures included in the design parameters document


