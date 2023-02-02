#!/bin/bash
: '
Comments:
Module for skull stripping using fsl brain extraction tool
Skull strip plumb anat (created during s0_deoblique)
'

#skullstrip anatomical for each subj
echo "*** SUBJECT: $sub ***"

#configure filenames
: 'directories configured in s0_config_directories.sh'
infile=${out_dir}/${sub}/${sub}.${anat}.nii			#deobliqued anat file
outfile=${out_dir}/${sub}/${sub}.${anat}_2				#final anat outfile

echo "infile is ${sub}.${anat}.nii"

  if [ ! -f ${outfile}.nii ] || [ $oflag ]; then
		: 'run code if outfile does not exist or
		if overwrite option is selected in driver'

		: 'check that infile exists'
		if [ -e ${infile} ]; then
			echo "infile exists"

			: 'if infile exists run brain extraction tool'
			echo "running brain extraction tool"
			bet ${infile} ${outfile}.nii -B -f 0.2 -g 0
      #bet ${infile} ${outfile}.nii -B -f 0.2 -g 1
			gunzip ${outfile}.nii.gz
			gunzip ${outfile}_mask.nii.gz

		else
			echo "missing infile"
			echo "terminating script"
			exit 1
		fi
	else
		: 'if outfile already exists and overwrite
		option not selected, do not run code'
		echo "outfile already exists"
	fi

echo "s0_bet.sh finished"
