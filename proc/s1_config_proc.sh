: 'configuration file for afni_proc.py fmri processing pipeline'

#define proc.py parameters for whole brain connectivity
connectivity_config="
afni_proc.py 
-subj_id    ${sub}      \
-dsets  ${epi_file}     \
-copy_anat  ${anat_file}        \                       
-script ${script_file} -scr_overwrite -out_dir ${out_dir}       \
-blocks despike tshift align tlrc volreg blur mask scale regress        \
-tcat_remove_first_trs  3      \
-tlrc_base  MNI152_T1_2009c+tlrc        \
-tlrc_NL_warp       \
-anat_has_skull no      \
-volreg_align_to    MIN_OUTLIER        \
-volreg_align_e2a       \
-volreg_tlrc_warp       \
-volreg_interp  heptic      \
-volreg_zpad    4       \
-mask_epi_anat  no      \
-blur_size  8       \
-regress_anaticor       \
-regress_reml_exec      \
-regress_censor_motion  0.5     \
-regress_censor_outliers    0.1     \
-regress_bandpass   0.01 0.01       \
-regress_apply_mot_types    demean deriv        \
-regress_est_blur_epits     \
-regress_est_blur_errts     "




#define proc.py parameters for whole brain task-based BOLD


#define proc.py parameters for whole-brain with pyhsiologcal extraction


#define proc.py parameters for SUIT (cerebellum)


#define proc.py parameters for SUIT (cerebellum) with pyhsiologcal extraction


