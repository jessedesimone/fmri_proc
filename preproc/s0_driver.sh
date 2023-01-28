#!/bin/bash
gen_error_msg="\
    Driver to run preprocessing modules and prepare for afni_proc.py processing

    Dependencies:
    Configure data directories in s0_config_directories.sh
    Update subj id list in configuration section of this script
    Update file naming for epi and anat infiles in configuration section of this script

    Note: deoblique anatomical outfile for [-d] is a dependency for skullstrip [-s]
    If running skullstrip only, -d must have been performed previously

    Usage: ./stage0_deoblique.sh [-h] [-d] [-s] [-o]
    Note: Outfile for [-d] is a dependency for [-s]
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
                *)  #no option passed
                    echo "no option passed"
                    echo -e "$gen_error_msg"
                    ;;
        esac
    done
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
sub_list=`cat ${proj_dir}/id_lists/test`

#define file naming
anat="T1"
epi="RS1"

for sub in ${sub_list[@]}; do mkdir -p ${out_dir}/${sub}; done
for sub in ${sub_list[@]}
do
    log_file=${out_dir}/${sub}/s0_log_${dt}.txt
    touch ${log_file}
    echo "$dt" 2>&1 | tee ${log_file}

    #============================handle options============================
    if [ "$oflag" ]
    then
        echo "!!! overwriting !!!" 2>&1 | tee -a ${log_file}
    fi
    if [ "$dflag" ]
    then
        echo "*** running s0_deoblique.sh ***" 2>&1 | tee -a ${log_file}
        source s0_deoblique.sh 2>&1 | tee -a ${log_file}
    fi
    if [ "$sflag" ]
    then
        echo "*** running s0_bet.sh ***" 2>&1 | tee -a ${log_file}
        source s0_bet.sh 2>&1 | tee -a ${log_file}
    fi
done
echo "s0_driver.sh finished" 2>&1 | tee -a ${log_file}
