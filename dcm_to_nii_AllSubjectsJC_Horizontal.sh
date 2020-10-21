	### DICOM 2 NIFTI for OCT- Horizontal scans
	## Jeiran Choupan October 2020


	Study_folder="PATH_TO_STUDY_FOLDER"
	INPUT_DIR=${Study_folder}/OCT_Heidelberg_DICOM
	OUTPUT_FOLDER="PATH_TO_OUTPUT_NIFTI_FOLDER"
	DICOM_FOLDER="NAME_OF_THE_DICOM_FOLDER"

	for p in ${OUTPUT_FOLDER}/2007

	do
		i=`echo $p | cut -d '/' -f12` # i is the subject name

		for l in ${p}/*OD
		do
			j=`echo $l | cut -d '/' -f13` # j is the name of the OD and OS folders

			for g in ${INPUT_DIR}/HCLV${i}_OD_OS_DICOM/*${j}*/Vol*/${DICOM_FOLDER}/
			# for g in ${INPUT_DIR}/HCLV${i}_OD_OS_DICOM/*${j}*/ho*/
			do
				DicomFolder=`echo $g | cut -d '/' -f14`

					# mkdir -p ${OUTPUT_FOLDER}

					## dcm2nii 
					dcm2niix -f oct -o ${OUTPUT_FOLDER}/${i}/${j} ${g}/

					## standardize the nifti file
					qit VolumeStandardize --input ${OUTPUT_FOLDER}/${i}/${j}/oct.nii --output ${OUTPUT_FOLDER}/${i}/${j}/oct_std.nii 

					## correct the bloody pixdim 
					matlab -nodisplay -nojvm -nosplash -r "addpath(genpath('PATH_TO_NIfTI_20140122_FOLDER'));\
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
					rm ${OUTPUT_FOLDER}/${i}/${j}/oct.nii
					rm ${OUTPUT_FOLDER}/${i}/${j}/oct_std.nii
					rm ${OUTPUT_FOLDER}/${i}/${j}/oct.json
				
			done
		done
	done