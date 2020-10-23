	### DICOM 2 NIFTI for OCT- Horizontal scans
	## Jeiran Choupan October 2020

	##############################################################################
	# This script works for the following folder arrangement of OCT DICOM data
	# /INPUT_DIR/SubjectsID=`i`/OD_or_OS_Folders=`j`/Volume_scans/Horizontal_DICOM_FOLDER

	
	INPUT_DIR=${Study_folder}/OCT_Heidelberg_DICOM
	SubjectsID=$1
	OD_or_OS_Folders=$2
	DICOM_FOLDER=$3 					# "NAME_OF_THE_DICOM_FOLDER"
	OUTPUT_FOLDER=$4  					# "PATH_TO_Subject's_OUTPUT_NIFTI_FOLDER"
	Study_folder=$5 					# "PATH_TO_STUDY_FOLDER"
	PATH_TO_NIfTI_20140122_FOLDER=$6			# "Path to Nifti Matlab toolbox"
	

	for p in ${OUTPUT_FOLDER}/SubjectsID

	do
		i=`echo $p | rev | cut -d '/' -f1 | rev`  # `i` is the subject name 

		for l in ${p}/OD_or_OS_Folders
		do
			j=`echo $l | rev | cut -d '/' -f1 | rev` # `j` is the name of the OD and OS folders 

			for g in ${INPUT_DIR}/HCLV${i}_OD_OS_DICOM/${j}/Volume_scans/${DICOM_FOLDER}
			
			do
				DicomFolder=`echo $g | rev | cut -d '/' -f1 | rev`
				mkdir -p ${OUTPUT_FOLDER}/${i}/${j}

				dcm2niix -f oct -o ${OUTPUT_FOLDER}/${i}/${j} ${g}/  # Convert Horizontal scans dicom file to nifti. The resulting nifti 
				# orientation is {-1 0 0;
				#		  0 1 0;
				#		  0 0 1}

				# Next, use the QIT software to standardize the converted nifti file orientation
				# into RAS {1 0 0;
				#	    0 1 0;
				#	    0 0 1}

				qit VolumeStandardize --input ${OUTPUT_FOLDER}/${i}/${j}/oct.nii --output ${OUTPUT_FOLDER}/${i}/${j}/oct_std.nii 
				
				# Then, use Matlab in the terminal and loads the standardized nifti OCT file
				# The following adjustments to the header of the nifti file changes the placements of pixel dimensions 
				
				matlab -nodisplay -nojvm -nosplash -r "addpath(genpath('${PATH_TO_NIfTI_20140122_FOLDER}'));\
				I = load_untouch_nii('${OUTPUT_FOLDER}/${i}/${j}/oct_std.nii');\
				px2 = I.hdr.dime.pixdim(2);\
				px3 = I.hdr.dime.pixdim(3);\
				I.hdr.dime.pixdim(2) = px3;\
				I.hdr.dime.pixdim(3) = px2;\
				dim1 = I.hdr.hist.srow_x(1);\
				dim2 = I.hdr.hist.srow_y(2);\
				I.hdr.hist.srow_x(1) = dim2;\
				I.hdr.hist.srow_y(2) = dim1;\
				save_untouch_nii(I,'${OUTPUT_FOLDER}/${i}/${j}/oct_std_horizontal.nii');\
				exit"
				# In the resulting Horizontal scan the Optical Nerve Head is in the right side of fovea for OD (Left side of nifti file), 
				# and in the left side of fovea for OS (Right side of nifti file)

				rm ${OUTPUT_FOLDER}/${i}/${j}/oct.nii
				rm ${OUTPUT_FOLDER}/${i}/${j}/oct_std.nii
				rm ${OUTPUT_FOLDER}/${i}/${j}/oct.json
				
			done
		done
	done
