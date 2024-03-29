#!/bin/bash
: '
Comments:
Module to debolique anat and epi images
Convert anat and epi from oblique (if applicable) to plump
Resample plumb anat and epi to RPI resolution
'

#deoblique anatomical for each subj
echo "++ SUBJECT: $sub"

#configure filenames
: 'directories configured in s0_config_directories.sh'
TAG=( $anat $epi )
for tag in ${TAG[@]}
do

	infile=${data_dir}/${sub}/${sub}.${tag}.nii				    #raw infile
	outfile_d=${out_dir}/${sub}/${sub}.${tag}_d.nii				#deoblique outfile
	outfile_r=${out_dir}/${sub}/${sub}.${tag}_r.nii				#resample outfile
	outfile=${out_dir}/${sub}/${sub}.${tag}.nii					#final outfile

	echo "++ infile is ${sub}.${tag}.nii"

	if [ ! -f ${outfile} ] || [ $oflag ]; then
		: 'run code if outfile does not exist or
		if overwrite option is selected in driver'

		if [ $oflag ]; then
			echo "++ outfile for $tag exists; OVERWRITING"
			rm -rf $outfile
		fi

		: 'check that infile exists'
		if [ -e ${infile} ]; then
			echo "++ infile exists"

			: 'check if infile is in oblique orientation'
			echo "++ checking oblique status"
			oblique_status=`3dinfo -is_oblique ${infile}`
			if [ $oblique_status -eq 1 ]; then
				echo "++ infile is oblique"
				echo "++ deobliquing"
				3dWarp -deoblique -prefix ${outfile_d} ${infile}

			else
				echo "++ infile is in plumb orientation"
				: 'copy from data_raw to data_proc'
				cp $infile $outfile_d
			fi

			: 'resample to RPI orientation'
			echo "++ resamping to RPI orientation"
			3dresample -orient RPI -prefix ${outfile_r} -inset ${outfile_d}

			: 'remove unnecessary files'
			rm ${outfile_d}
			mv ${outfile_r} ${outfile}

		else
			echo "++ missing infile"
			echo "++ terminating script"
			exit 1
		fi

	else
		echo "++ outfile for $tag already exists; use -o option to overwrite"
	fi

done
echo "++ s0_deoblique.sh finished"
