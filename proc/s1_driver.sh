#!/bin/bash
gen_error_msg="\
    Driver to run afni_proc.py
    Note: task BOLD, SUIT, physiol extraction not currently operational; to be added in later iterations
    afni_proc.py parameters for corresponding options are defined in s1_config_proc.ini
    
    Usage: ./s1_driver.sh [-h] [-c] [-t] [-s] [-p] [-o]
    Arguments
    -h  help
    -c  run whole-brain connectivity
    -t  run whole-brain task BOLD
    -s  run SUIT
    -p  run physiol extraction
    -o  overwrite existing output files
    "
    while getopts ":hctpseo" opt; do
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
                p) #WB with physio extraction option
                    pflag=1
                    ;;
                s) #SUIT option
                    sflag=1
                    ;;
                e) #SUIT with physio extraction option
                    eflag=1
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

for sub in ${sub_list[@]}
do
    #configure output files
    out_file=${out_dir}/${sub}/afni.proc.${dt}.out
    script_file=${out_dir}/${sub}/afni.proc.${dt}.script

    #configure input files
    : 'define epi and ant files; exit code if infiles do not exist'
    epi_file=${data_dir}/${sub}/${sub}.RS1.nii
    anat_file=${out_dir}/${sub}/${sub}.spgr2.nii

    if [[ -f ${epi_file} ]] && [[ -f ${anat_file} ]]; then
        : 'proceed with data processing if files exist'
        if [ "$oflag" ]; then
        echo "!!! overwriting output directory !!!" 
        : 'remove all files except for anat infile, which
        was created during s0 data preprocessing'
        cd ${out_dir}/${sub}
        shopt -s extglob
        rm -v !(${sub}.spgr2.nii)
        cd ${code_dir}
        fi
        if [ "$cflag" ]; then
        echo "preparing data for connectivity processing"
        fi
    else
        echo "!!! ERROR !!! anat and/or epi infiles not found; quitting"
        exit 1
    fi

done

: '
    if [ "$cflag" ]; then
        : ' source connectivity afni_proc.py option from config file' 
        #-------------afni_proc.py-------------
        source s1_config_proc.ini; connectivity_config
        echo "tcsh -xef ${script_file} | tee ${out_file}" >> ${job_file}
        echo "connectivity afni_proc.py script created for ${sub}"
    fi



#run job file
: 'this will run the afni_proc.py script_file created for each subject'
chmod +x ${job_file}        #make job file executable
#source ${job_file}          #run job file

echo "s1_driver.sh finished" 
'