#!/bin/bash

: '
Comments:
module to debolique anatomical T1 images and resample to RPI resolution
uses 3dinfo in AFNI to check oblique status
if input anatomical is oblique, use 3dWarp to deoblique
uses 3dresample to convert to RPI orientation

Input file:
${sub}.T1.nii

Output file:
${sub}.T1.nii - overwrites naming of original file
'

#define data directory
top=<path/to/top/dir>
proj_dir=<path/to/project/dir>
data_dir=<path/to/data/dir>

#define subject list
SUB=`cat <path/to/subject/id/list>`

#deoblique anatomical for each subj
for sub in ${SUB[@]}
do
	infile=${data_dir}/${sub}/${sub}.T1.nii
	outfile=${data_dir}/${sub}/${sub}.T1_2.nii
	echo "input image is $infile"

	#create raw data backup
	echo "creating raw data backup"
	backup_dir=${data_dir}/${sub}/raw
	if [ ! -d ${backup_dir}]; then
		mkdir -p ${backup_dir}
		cp ${data_dir}/${sub}/${sub}.*.nii ${backup_dir}/
	fi

	# Check for input image in subj directory
	if [ -e ${infile} ]; then
		echo "$infile exists"
		echo "checking oblique status"
		oblique_status=`3dinfo -is_oblique ${infile}`

		if [ $oblique_status -eq 1 ]; then
			echo "$infile is oblique"
			echo "deobliquing"
			3dWarp -deoblique -prefix ${outfile} ${infile}
			: 'remove infile and rename the outfile to the original name'
			rm ${infile}
			mv ${outfile} ${infile}
		else
			echo " $infile is not oblique skipping condition"
		fi

	#resample anatomical to RPI orientation
	echo "resaming anatomical RPI orientation"
	3dresample -orient RPI -prefix $outfile -inset $infile
	rm ${infile}
	mv ${outfile} ${infile}

	else
		echo "!!! ERROR - no input file for $sub , qutting !!!"
		Exit 0
	fi

done		#done SUB
