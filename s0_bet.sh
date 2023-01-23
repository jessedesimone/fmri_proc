#!/bin/bash
: '
Comments:
Module for skull stripping using fsl brain extraction tool

infile=${out_dir}/${sub}/${sub}.spgr.nii - deobliqued and resampled T1 output image from s0_deoblique.sh
outfile=${out_dir}/${sub}/${sub}.spgr2.nii.gz - skullstrip/brain extract T1
'

#skullstrip anatomical for each subj
echo "*** SUBJECT: $sub ***"

#configure filenames
: 'directories configured in s0_config_directories.sh'
infile=${out_dir}/${sub}/${sub}.spgr.nii				#raw infile
outfile=${out_dir}/${sub}/${sub}.spgr2				#final outfile

echo "infile is ${sub}.spgr.nii"

  if [ ! -f ${outfile}.nii.gz ] || [ $oflag ]; then
		: 'run code if outfile does not exist or
		if overwrite option is selected in driver'

		: 'check that infile exists'
		if [ -e ${infile} ]; then
			echo "infile exists"

			: 'if infile exists run brain extraction tool'
			echo "running brain extraction tool"
			bet ${infile} ${outfile}.nii -B -f 0.2 -g 0

		else
			echo "!!! ERROR !!! missing infile"
			exit 0
		fi
	else
		: 'if outfile already exists and overwrite
		option not selected, do not run code'
		echo "outfile already exists"
	fi

echo "s0_bet.sh finished"
