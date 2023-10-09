#!/bin/bash

head -8 ../CHANGELOG.md

gen_error_msg="\
    Driver to run preprocessing modules and prepare for afni_proc.py processing

    Dependencies:
    Configure data directories in s0_config_directories.sh
    Update id_subj list in configuration section of this script
    Update file naming for epi and anat infiles in configuration section of this script

    Note: deoblique [-d] option is a dependency for skullstrip [-s] option

    Usage: ./stage0_deoblique.sh [-h] [-d] [-s] [-o]
    Arguments
        -h  help
        -d  deoblique
        -s  skullstrip
        -o  overwrite
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
        esac
    done
    if [ $OPTIND -eq 1 ]; then 
        echo "++ driver.sh requires argument"
        echo "$gen_error_msg"
        exit 1
        fi
    shift $((OPTIND -1))

#============================configuration============================
#set directories
: 'call directories.sh'
source s0_config_directories.sh

#set datetime
dt=$(date "+%Y.%m.%d.%H.%M.%S")

#check dependencies
: 'uncomment if you need to check dependencies
code should run fine on current LRN systems'
source s0_dependencies.sh

#define subject list
sub_list=`cat ${list_dir}/tests/id_subj.txt`

#define file naming
anat="t1w"
epi="task_rest_bold"

for sub in ${sub_list[@]}; do mkdir -p ${out_dir}/${sub}; done
for sub in ${sub_list[@]}
do
    log_file=${out_dir}/${sub}/s0_log_${dt}.txt
    touch ${log_file}
    echo "++ $dt" 2>&1 | tee ${log_file}

    #============================handle options============================
    if [ "$oflag" ]; then
        : 'if -o option given then remove files from output directory for each subject'
        echo "++ overwrite option selected" 2>&1 | tee -a ${log_file}
        if [ "$oflag" ] && [ ! "$dflag" ]; then
            echo "++ -d option must be passed for overwriting" 
            if [ ! "$sflag" ]; then
                echo "++ -s option must be passed for overwriting"
            fi
        fi
    fi 
    if [ "$dflag" ]; then
        : 'if -d option given then run deoblique and resample for each subject'
        echo "++ running s0_deoblique.sh" 2>&1 | tee -a ${log_file}
        source s0_deoblique.sh 2>&1 | tee -a ${log_file}
    fi
    if [ "$sflag" ]; then
        : 'if -s option given then run skull strip/BET for each subject'
        echo "++ running s0_bet.sh" 2>&1 | tee -a ${log_file}
        source s0_bet.sh 2>&1 | tee -a ${log_file}
    fi
done
echo "++ s0_driver.sh finished" 2>&1 | tee -a ${log_file}
