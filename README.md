# Retina_OCT_dcm2nii
This repository contains code for converting the optical coherence tomography (OCT) data acquired by Heidelberg machine from Dicom (.dcm) format into Nifti (.nii).  

## Motivation 
The Dicom OCT data used to develop this code were derived using the Heidelberg software. 
Results of Horizontal and Vertical scans after conventional dicom2nifti transformation had image orientation and dimension that did not follow the Neurological (RAS) format. 
The high resolution volume OCT data for this repository were acquired in 30 by 20 field of view. Horizontal scans cover the optic nerve head and the fovea, and the vertical scans contain the fovea only.

In the resulting Vertical scan the Optical Nerve Head is in Inferior section for OD and in Superior section for OS.
In the resulting Horizontal scan the Optical Nerve Head is in the right side of fovea for OD (Left side of nifti file), and in the left side of fovea for OS (Right side of nifti file)

## Installation 
Rhis repo requires dcm2niix, QIT and MATLAB - to install them:
- go to [dcm2nii](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage)
- go to [QIT](http://cabeen.io/qitwiki/index.php?title=Installation) 
- go to [MATLAB R2019b](https://www.mathworks.com/downloads/web_downloads/?s_iid=hp_ff_t_downloads)
- go to [MATLAB toolbox](https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image)


## Implementatio
The folder arrangement for this repository is as follow:
`/INPUT_DIR/SubjectsID/OD_or_OS_Folders/Volume_scans/Horizontal_or_Vertical_DICOM_FOLDER` 

To run the code for Horizontal scans:
/PATH_TO:dcm_to_nii_AllSubjectsJC_Horizontal.sh `SubjectsID` `OD_or_OS_Folders` `DICOM_FOLDER_NAME` `Path_to_OUTPUT_FOLDER` `Path_to_Study_DICOM_folder` `PATH_to_NIfTI_20140122_FOLDER`

To run the code for Vertical scans:
/PATH_TO:dcm_to_nii_AllSubjectsJC_Vertical.sh `SubjectsID` `OD_or_OS_Folders` `DICOM_FOLDER_NAME` `Path_to_OUTPUT_FOLDER` `Path_to_Study_DICOM_folder` `PATH_to_NIfTI_20140122_FOLDER`

## Author 
Jeiran Choupan, October 2020.

for questions contact choupan@usc.edu.

## Acknowledgment
this was not possible without liberal contributions from dcm2nii, QIT and Matlab
