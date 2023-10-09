#!/bin/bash
: '
Comments:
Module for skull stripping using FSL brain extraction tool or AFNI 3dSkullStrip
Skull strip plumb anat (created during s0_deoblique)
'

#skullstrip anatomical for each subj
echo "++ SUBJECT: $sub"

#configure filenames
: 'directories configured in s0_config_directories.sh'
infile=${out_dir}/${sub}/${sub}.${anat}.nii			#deobliqued anat file
outfile=${out_dir}/${sub}/${sub}.${anat}_2				#final anat outfile

echo "++ infile is ${sub}.${anat}.nii"

  if [ ! -f ${outfile}.nii ] || [ $oflag ]; then
		: 'run code if outfile does not exist or
		if overwrite option is selected in driver'

		: 'check that infile exists'
		if [ -e ${infile} ]; then
			echo "++ infile exists"

			: 'run a series of checks on the infile'

			: 'if infile is oblique then terminate'
			oblique_status=`3dinfo -is_oblique ${infile}`
			if [ $oblique_status -eq 1 ]; then
				echo "++ infile is oblique"
				echo "++ please run ./s0_driver.sh -ds "
				echo "++ terminating script"
				exit 1
			else
				echo "++ infile is plumb"
			fi

			: 'if infile not RPI orientation then terminate'
			target_status="RPI"
			orient_status=`3dinfo -orient ${infile}`
			if [ $orient_status != $target_status ]; then
				echo "++ infile is not in RPI orientation"
				echo "++ please run ./s0_driver.sh -ds "
				echo "++ terminating script"
				exit 1
			else
				echo "++ $infile in proper orientation"
			fi

			: 'if infile exists run brain extraction tool'
			echo "++ running brain extraction tool"
			#/usr/local/fsl/bin/bet ${infile} ${outfile}.nii -B -f 0.2 -g 0		#use fsl bet
			3dSkullStrip -input ${infile} -prefix ${outfile}.nii		#use afni 3dSkullStrip
			gunzip ${outfile}.nii.gz
			gunzip ${outfile}_mask.nii.gz

		else
			echo "++ missing infile"
			echo "++ terminating script"
			exit 1
		fi
	else
		: 'if outfile already exists and overwrite
		option not selected, do not run code'
		echo "++ outfile already exists"
	fi

echo "++ s0_bet.sh finished"
