# ASLprep-CBF-Analysis
ASLprep pipeline for processing arterial spin labeling (ASL) MRI data and extracting cerebral blood flow (CBF) measurements in native space, using FSL and Freesurfer tools. Includes scripts for co-registration, and CBF calculation per region of interest. Created by Jessica Archibald.

## ASL Analysis Pipeline
This repository contains a set of scripts to preprocess and analyze arterial spin labeling (ASL) MRI data.

## Prerequisites
The following software packages must be installed on your computer to run the scripts in this repository:

ASLprep
FSL
Docker

## Usage
Organize your data according to the BIDS standard.
Run ASLprep to preprocess your ASL data.
Use the asl_cbf_extraction.sh script to extract CBF values from specific brain regions of interest.
