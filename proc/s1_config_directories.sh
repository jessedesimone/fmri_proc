#!/bin/bash
: 'configure directories for data processing stage'
top=/media/mcuser/Data2/desimone                        #parent directory
code_dir=${top}/code/fmri_proc/proc                     #code directory (location of proc scripts)
proj_dir=${top}/ab4240_imaging/resting_state            #project directory
data_dir=${proj_dir}/data_proc                          #data directory (location of proc_py infiles)
job_dir=${proj_dir}/jobs; mkdir -p ${job_dir}           #job directory
