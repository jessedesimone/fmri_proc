#!/bin/bash

: '
Comments:
module for skull stripping using fsl brain extraction tool

Files:
Input file:
${sub}.T1.nii	- raw T1 anatomical image

Output file:
${out_dir}/${sub}/${sub}.T1.nii - deobliqued and resampled T1 anatomical image
'
SUB=$sub_list			#defined in stage0_driver.sh



bet $input_img $output_img -B -f 0.2 -g 0
    #rm $input_img
    3dcopy $output_img.gz $output_img
    rm $output_img.gz
