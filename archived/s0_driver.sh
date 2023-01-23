#!/bin/bash
gen_error_msg="\
    Driver to run modules to prepare for afni_preproc package
    Outfile for [-d] is a dependency for [-s]

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
                *)  #no option passed
                    echo "no option passed"
                    echo -e "$gen_error_msg"
                    ;;
        esac
    done
    shift $((OPTIND -1))

#set directories
: 'call directories.sh'
source s0_config_directories.sh

#set datetime
dt=$(date "+%Y.%m.%d.%H.%M.%S")

#create job file
job_file=${job_dir}/${dt}_s0.txt
touch ${job_file}
echo "$dt" 2>&1 | tee ${job_file}

#check dependencies
: 'uncomment if you need to check dependencies
code should run fine on current LRN systems'
source s0_dependencies.sh 2>&1 | tee -a ${job_file}

sub_list=`cat ${proj_dir}/id_lists/id_sub_quest_mci_only`
for sub in ${sub_list[@]}; do mkdir -p ${out_dir}/${sub}; done
for sub in ${sub_list[@]}
do
    if [ "$oflag" ]
    then
        echo "!!! overwriting !!!" 2>&1 | tee -a ${job_file}
    fi
    if [ "$dflag" ]
    then
        echo "*** running s0_deoblique.sh ***" 2>&1 | tee -a ${job_file}
        source s0_deoblique.sh 2>&1 | tee -a ${job_file}
    fi
    if [ "$sflag" ]
    then
        echo "*** running s0_bet.sh ***" 2>&1 | tee -a ${job_file}
        source s0_bet.sh 2>&1 | tee -a ${job_file}
    fi
done
echo "s0_driver.sh finished" 2>&1 | tee -a ${job_file}
