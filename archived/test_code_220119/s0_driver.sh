#!/bin/bash

#check dependencies
: 'uncomment if you need to check dependencies
code should run fine on current LRN systems'
#source s0_dependencies.sh

top=/media/mcuser/Data2/desimone      #parent directory
proj_dir=${top}/ab4240_imaging/resting_state      #project directory
data_dir=${proj_dir}/raw_data       #raw data directory
out_dir=${proj_dir}/data_preproc; mkdir -p ${out_dir}     #output directory

sub_list=`cat ${proj_dir}/id_lists/test`      #subject list
for sub in ${sub_list[@]}
do
    if  [ ! -d ${out_dir}/${sub} ]; then
        mkdir ${out_dir}/${sub}
    fi

    gen_error_msg="\

    Driver script to run modules to prepare for afni_preproc package
    Options to run deoblique and skullstrip separately or in parallel
    If running skullstrip only, the anatomical images must be put into the output directory specified by deoblique.sh

    Usage: ./stage0_deoblique.sh [-h] [-d] [-s] [-o]
    Arguments
    -h  help
    -d  deoblique
    -s  skullstrip
    -o  overwrite existing output file
    "
    while getopts ":hdso" opt; do
        case ${opt} in
                h|\?) #help option
                    echo -e "$gen_error_msg"
                    exit 1
                    ;;
                d) #deoblique only option
                    dflag=1
                    ;;
                s) #skullstrip only option
                    sflag=1
                    ;;
                o) #overwrite
                    oflag=1
                    ;;
                *)  #no option passed
                    echo "no option passed"
                    echo -e "$gen_error_msg"
                    ;;
        esac
    done
    shift $((OPTIND -1))

    if [ "$dflag" ]
    then
        echo "running deoblique.sh"
        source deoblique2.sh
    fi
    if [ "$sflag" ]
    then
        echo "running bet.sh"
        #source bet.sh
    fi
    if [ "$oflag" ]
    then
        echo "!!! overwriting !!!"
    fi

done
