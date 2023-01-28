# fmri_proc
functional MRI (pre)processing package for task or resting state analysis

## preproc
preprocessing pipeline
performs deoblique and orientation resampling on fmri and anatomical images

performs skillstrip (brain extraction) on anatomical image

./preproc/s0_driver -h for help

## proc
processing pipeline

performs afni_proc.py processing using preproc output files as inputs

./preproc/s1_driver -h for help
