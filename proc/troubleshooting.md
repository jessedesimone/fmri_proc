# afni_proc.py troubleshooting

## Discrepant image coordinates
raw epi and anat files do not share the same coordinates (minimal to no overlay in image acquisition space)

### troubleshooting options:
opt 1: alter align_anat_epi.py options using -align_opts_aea [options]
opt 2: center the edge voxel for the anat and epi files using 3drefit
3drefit -xorigin cent $anat
3drefit -yorigin cent $anat
3drefit -zorigin cent $anat
3drefit -xorigin cent $epi
3drefit -yorigin cent $epi
3drefit -zorigin cent $epi

