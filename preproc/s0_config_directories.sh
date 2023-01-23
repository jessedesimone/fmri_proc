#!/bin/bash
: 'configure directories for data preprocessing stage'
top=/media/mcuser/Data2/desimone                        #parent directory
proj_dir=${top}/ab4240_imaging/resting_state            #project directory
data_dir=${proj_dir}/data_raw                           #raw data directory
out_dir=${proj_dir}/data_proc; mkdir -p ${out_dir}      #output directory
job_dir=${proj_dir}/jobs; mkdir -p ${job_dir}           #job directory
