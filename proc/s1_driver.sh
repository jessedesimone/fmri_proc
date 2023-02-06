#!/bin/bash
gen_error_msg="\
    Driver to run afni_proc.py
    Note: task BOLD, SUIT, physiol extraction not currently operational; to be added in later iterations
    afni_proc.py parameters for each option are defined in s1_config_proc.ini

    Dependencies:
    Run preproc pipeline (deoblique, resample, skullstrip)
    Configure data directories in s1_config_directories.sh
    Configure afni_proc.py options in s1_config_proc.ini
    Update subj id list in configuration section of this script
    Update file naming for epi and anat infiles in configuration section of this script

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

#============================configuration============================
: 'user input may be required here'
#set directories
: 'call directories.sh'
source s1_config_directories.sh

#enable extended globbing
: 'enables pattern matching for removing files with overwrite option'
shopt -s extglob

#set datetime
: 'used for datetime stamp on job and script files'
dt=$(date "+%Y.%m.%d.%H.%M.%S")

#check dependencies
: 'uncomment if you need to check dependencies
code should run fine on current LRN systems'
source s1_dependencies.sh

#create job file
: 'job file executes afni_proc.py script for each subject'
job_file=${job_dir}/run_proc_py.${dt}

#define subject list
sub_list=`cat ${proj_dir}/id_lists/id_sub_quest_mci_only`

#define file naming
anat="T1_2"             #deobliqued, resampled, skull stripped anatomical image
epi="RS1"               #deobliqued, resampled epi image

for sub in ${sub_list[@]}
do
    #configure infiles
    epi_file=${data_dir}/${sub}/${sub}.${epi}.nii                #epi file
    anat_file=${data_dir}/${sub}/${sub}.${anat}.nii              #anat file

    #configure outdirs and outfiles
    out_file=${data_dir}/${sub}/s1_afni.proc.${dt}.out           #afni_proc.py log
    script_file=${data_dir}/${sub}/s1_afni.proc.${dt}.script     #afni_proc.py script
    out_dir=${data_dir}/${sub}/proc_py                           #proc.py output directory

    #============================handle options============================
    if [ "$oflag" ]; then
        echo "!!! overwriting output directory !!!"
        : 'remove all files except infiles and preproc log'
        rm -rf ${data_dir}/${sub}/s1_afni.proc.*
        cd ${data_dir}/${sub}
        if [ -d $out_dir ]; then
            echo "proc_py outdir exists"
            rm -vr $out_dir
        fi
        cd ${code_dir}
    fi
    if [[ -f ${epi_file} ]] && [[ -f ${anat_file} ]]; then
        : 'proceed with data processing if files epi and anat exist'
        if [ "$cflag" ]; then
            : ' source connectivity afni_proc.py option from config file'
            source s1_config_proc.ini
            mid=$connectivity_config_mid
        fi
    else
        : 'terminate script if missing input files'
        echo "anat and/or epi infiles not found for $sub"
        echo "terminating script"
        exit 1
    fi
#============================afni_proc.py============================
    : 'initialize afni_proc.py script'
    afni_proc.py \
        -subj_id ${sub} \
        -dsets ${epi_file} \
        -copy_anat ${anat_file} \
        -script ${script_file} -scr_overwrite -out_dir ${out_dir} \
        $mid

    echo "tcsh -xef ${script_file} | tee ${out_file}" >> ${job_file}
    echo "afni_proc.py script created for ${sub}"

done
#============================Run afni_proc.py job file============================
: 'this will make job file executatble and
run script file for each subject'
chmod +x ${job_file}        #make job file executable
: 'option to execute job file by uncommenting below'
#source ${job_file}          #run job file

echo "s1_driver.sh finished"
