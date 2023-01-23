#!/bin/bash
: '
Comments:
Module to debolique anatomical T1 images and resample to RPI resolution
Convert anatomical from oblique (if applicable) to plump
Resample plumb anatomical to RPI orientation

infile=${data_dir}/${sub}/${sub}.T1.nii - raw T1 anatomical image
outfile=${out_dir}/${sub}/${sub}.spgr.nii - deobliqued and resampled T1 anatomical image
'

#deoblique anatomical for each subj
echo "*** SUBJECT: $sub ***"

    #configure filenames
: 'directories configured in s0_config_directories.sh'
infile=${data_dir}/${sub}/${sub}.T1.nii				    #raw infile
outfile_d=${out_dir}/${sub}/${sub}.spgr_d.nii			#deoblique outfile
outfile_r=${out_dir}/${sub}/${sub}.spgr_r.nii			#resample outfile
outfile=${out_dir}/${sub}/${sub}.spgr.nii				#final outfile

echo "infile is ${sub}.T1.nii"

if [ ! -f ${outfile} ] || [ $oflag ]; then
	: 'run code if outfile does not exist or
	if overwrite option is selected in driver'

	: 'check that infile exists'
	if [ -e ${infile} ]; then
		echo "infile exists"

		: 'check if infile is in oblique orientation'
		echo "checking oblique status"
		oblique_status=`3dinfo -is_oblique ${infile}`
		if [ $oblique_status -eq 1 ]; then
			echo "infile is oblique"
			echo "deobliquing"
			3dWarp -deoblique -prefix ${outfile_d} ${infile}

		else
			echo "infile is in plumb orientation"
			cp $infile $outfile_d

		fi

		: 'resample anatomical to RPI orientation'
		echo "resamping anatomical to RPI orientation"
		3dresample -orient RPI -prefix ${outfile_r} -inset ${outfile_d}
		rm ${outfile_d}
		mv ${outfile_r} ${outfile}

	else
		echo "!!! ERROR !!! missing infile"
		exit 0

	fi

else
	: 'if outfile already exists and overwrite
	option not selected, do not run code'
	echo "outfile already exists"

fi

echo "s0_deoblique.sh finished"
