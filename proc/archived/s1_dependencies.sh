#!/bin/bash
set -e

: 'module to check dependencies'
echo -n "checking dependencies >>>>>> "
command -v fsl >/dev/null 2>&1 || { echo >&2 "fsl is not installed.  Aborting."; exit 1; }
command -v afni >/dev/null 2>&1 || { echo >&2 "afni is not installed.  Aborting."; exit 1; }
command -v matlab >/dev/null 2>&1 || { echo >&2 "Matlab is not installed.  Aborting."; exit 1; }
command -v R >/dev/null 2>&1 || { echo >&2 "R is not installed.  Aborting."; exit 1; }
command -v dcm2nii >/dev/null 2>&1 || { echo >&2 "dcm2nii is not installed.  Aborting."; exit 1; }
command -v parallel >/dev/null 2>&1 || { echo >&2 "parallel is not installed.  Aborting."; exit 1; }
echo "good"
