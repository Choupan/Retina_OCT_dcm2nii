	### DICOM 2 NIFTI for OCT- Vertical scans
	## Jeiran Choupan October 2020

	##############################################################################
	# This script works for the following folder arrangement of OCT DICOM data
	# /INPUT_DIR/SubjectsID=`i`/OD_or_OS_Folders=`j`/Volume_scans/Vertical_DICOM_FOLDER

	INPUT_DIR=${Study_folder}/OCT_Heidelberg_DICOM
	SubjectsID=$1
	OD_or_OS_Folders=$2
	DICOM_FOLDER=$3 					# "NAME_OF_THE_DICOM_FOLDER"
	OUTPUT_FOLDER=$4  					# "PATH_TO_Subject's_OUTPUT_NIFTI_FOLDER"
	Study_folder=$5 					# "PATH_TO_STUDY_FOLDER"
	PATH_TO_NIfTI_20140122_FOLDER=$6 	# "Path to Nifti Matlab toolbox"

	for p in ${OUTPUT_FOLDER}/SubjectsID

	do
		i=`echo $p | rev | cut -d '/' -f1 | rev`     # `i` is the subject name 

		for l in ${p}/OD_or_OS_Folders 			  	  
		do
			j=`echo $l | rev | cut -d '/' -f1 | rev` # `j` is the name of the OD and OS folders 

			for g in ${INPUT_DIR}/HCLV${i}_OD_OS_DICOM/${j}/Volume_scans/${DICOM_FOLDER}

			do
				DicomFolder=`echo $g | rev | cut -d '/' -f1 | rev` # `-f14` needs to be adjusted based on the folder subdirectories
				mkdir -p ${OUTPUT_FOLDER}/${i}/${j}
				
				dcm2niix -f oct -o ${OUTPUT_FOLDER}/${i}/${j} ${g}/  # Convert Vertical scans dicom file to nifti. The resulting nifti 
				# orientation is {0  0 1;
				#				  0 1 0;
				#		  	 	  1 0 0}

				# Then, use Matlab in the terminal and loads the converted nifti OCT file
				# The following adjustments to the header of the nifti file changes the placements of pixel dimensions, and
				# changes the orientation of the nifti file
				# into RAS {1 0 0;
				#			0 1 0;
				#			0 0 1}

				matlab -nodisplay -nojvm -nosplash -r "addpath(genpath('${PATH_TO_NIfTI_20140122_FOLDER}'));\
				I = load_untouch_nii('${OUTPUT_FOLDER}/${i}/${j}/oct.nii');\
				px2 = I.hdr.dime.pixdim(2);\
				px3 = I.hdr.dime.pixdim(3);\
				I.hdr.dime.pixdim(2) = px3;\
				I.hdr.dime.pixdim(3) = px2;\
				I.hdr.dime.pixdim(1) = 0;\
				I.hdr.dime.pixdim(5:8) = 1;\
				I.hdr.dime.datatype = 16;\
				I.hdr.dime.bitpix = 32;\
				I.hdr.dime.scl_slope =0;\
				I.hdr.dime.xyzt_units =0;\
				dim1 = I.hdr.hist.srow_x(3);\
				dim2 = I.hdr.hist.srow_y(2);\
				dim3 = I.hdr.hist.srow_z(1);\
				I.hdr.hist.srow_x(3) = 0;\
				I.hdr.hist.srow_y(2) = 0;\
				I.hdr.hist.srow_z(1) = 0;\
				I.hdr.hist.srow_x(1) = dim2;\
				I.hdr.hist.srow_y(2) = dim3;\
				I.hdr.hist.srow_z(3) = dim1;\
				I.hdr.hist.srow_x(4) = I.hdr.hist.srow_x(1);\
				I.hdr.hist.srow_y(4) = I.hdr.hist.srow_y(2);\
				I.hdr.hist.srow_z(4) = I.hdr.hist.srow_z(3);\
				I.hdr.hist.qoffset_x = 0;\
				I.hdr.hist.qoffset_y = 0;\
				I.hdr.hist.quatern_c = 0;\
				I.hdr.hist.qform_code = 0;\
				save_untouch_nii(I,'${OUTPUT_FOLDER}/${i}/${j}/oct_std_Vertical.nii');\
				exit"

				# In the resulting Vertical scan the Optical Nerve Head is in Inferior section for OD and in Superior section for OS
				rm ${OUTPUT_FOLDER}/${i}/${j}/oct.nii
				rm ${OUTPUT_FOLDER}/${i}/${j}/oct.json
			
				
			done
		done
	done