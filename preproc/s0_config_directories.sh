#!/bin/bash
: 'configure directories for data preprocessing'
top=/Users/jessedesimone/desimone_github        #parent directory
proj_dir=${top}/fmri_proc       #project directory
data_dir=${proj_dir}/data_raw       #raw data directory
out_dir=${proj_dir}/data_proc; mkdir -p ${out_dir}      #output directory
list_dir=${proj_dir}/id_lists       #subject lists directory
