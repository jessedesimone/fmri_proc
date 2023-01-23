# fmri_proc
package for preprocessing functional MRI data for activation or connectivity mapping

## instruction guide

### step 1 deoblique.sh
module to convert anatomical T1 image from oblique to plumb
resamples plumb anatomic imaging to radiological view (RPI)

### step 2 bet.sh
module for brain extraction (skull stripping) using fslbet function
