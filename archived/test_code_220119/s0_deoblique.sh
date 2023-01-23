#!/bin/bash

: '
Comments:
module to debolique anatomical T1 images and resample to RPI resolution
uses 3dinfo in AFNI to check oblique status
if input anatomical is oblique, use 3dWarp to deoblique
uses 3dresample to convert to RPI orientation

Files:
Input file:
${sub}.T1.nii	- raw T1 anatomical image

Output file:
${out_dir}/${sub}/${sub}.T1.nii - deobliqued and resampled T1 anatomical image
'
SUB=$sub_list			#defined in stage0_driver.sh

#deoblique anatomical for each subj
for sub in ${SUB[@]}
do
	echo "*** SUBJECT: $sub ***"
	: 'directories configured in stage0_driver.sh'
	infile=${data_dir}/${sub}/${sub}.T1.nii				#raw infile
	outfile_d=${out_dir}/${sub}/${sub}.T1_d.nii			#deoblique outfile
	outfile_r=${out_dir}/${sub}/${sub}.T1_r.nii			#resample outfile
	outfile=${out_dir}/${sub}/${sub}.T1.nii				#final outfile

	echo "input image is ${sub}.T1.nii"

    if [ ! -f ${outfile} ] || [ $oflag ]; then
        #run code
        echo "run code"

        if [ -e ${infile} ]; then
		echo "infile exists"
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

	    #resample anatomical to RPI orientation
        echo "resamping anatomical to RPI orientation"
        3dresample -orient RPI -prefix ${outfile_r} -inset ${outfile_d}
        rm ${outfile_d}
        mv ${outfile_r} ${outfile}

        else
            echo "!!! ERROR !!! missing infile"
            Exit 0
        fi

    else
        echo "outfile already exists"
    fi
done