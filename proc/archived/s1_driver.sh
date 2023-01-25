#!/bin/bash
gen_error_msg="\
    Driver to run afni_proc.py
    Note: task BOLD, SUIT, physiol extraction not currently operational; to be added in later iterations
    afni_proc.py parametersn for corresponding options are defined in s1_config_proc.ini
    
    Usage: ./s1_driver.sh [-h] [-c] [-t] [-s] [-p] [-o]
    Arguments
    -h  help
    -c  run whole-brain connectivity
    -t  run whole-brain task BOLD
    -s  run SUIT
    -p  run physiol extraction
    -o  overwrite 
    "
    while getopts ":hctsp" opt; do
        case ${opt} in
                h|\?) #help option
                    echo -e "$gen_error_msg"
                    exit 1
                    ;;
                c) #WB connectivity option
                    cflag=1
                    ;;
                t) #WB task BOLD option
                    tflag=1
                    ;;
                s) #SUIT option
                    sflag=1
                    ;;
                p) #physio extraction option
                    pflag=1
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
source s1_config_directories.sh

#set datetime
dt=$(date "+%Y.%m.%d.%H.%M.%S")

#check dependencies
: 'uncomment if you need to check dependencies
code should run fine on current LRN systems'
#source s1_dependencies.sh

#create job file
: 'job file is executable script to run afni_proc.py for all subjects;
calling afni_proc.py script for each subject'
job_file=${job_dir}/run_proc_py.${dt}

#define subject list
sub_list=`cat ${proj_dir}/id_lists/test`

#create output directory if not exist
: 'output directory should exist already is preprocessing was performed'
#for sub in ${sub_list[@]}; do mkdir -p ${out_dir}/${sub}; done

for sub in ${sub_list[@]}
do
    if [ "$oflag" ]
    then
        echo "!!! overwriting !!!" 
        if [ -d ${out_dir}/${sub} ]; then
            rm -rf ${out_dir}/${sub}

    fi




    if [ "$cflag" ]
    then
        echo "*** connectivity analysis ***" 
        source s0_deoblique.sh 
    fi

done

#run job file
source ${job_file}

echo "s1_driver.sh finished" 
