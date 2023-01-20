#!/bin/bash
top=/media/mcuser/Data2/desimone                        #parent directory
proj_dir=${top}/ab4240_imaging/resting_state            #project directory
data_dir=${proj_dir}/raw_data                           #raw data directory
out_dir=${proj_dir}/data_preproc; mkdir -p ${out_dir}   #output directory
job_dir=${out_dir}/jobs; mkdir -p ${job_dir}           #job directory