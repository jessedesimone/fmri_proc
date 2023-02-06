# afni_proc.py troubleshooting

## Discrepant image coordinates
raw epi and anat files do not share the same coordinates (minimal to no overlay in image acquisition space)

### troubleshooting options:
opt 1: configure afni_proc.py using -align_opts_aea [-big_move] [-giant_move] [-ginormous_move] and different cost functions
opt 2: center the edge voxel for the epi files using 3drefit
[3drefit -xorigin cent $epi]
[3drefit -yorigin cent $epi]
[3drefit -zorigin cent $epi]
opt 3: combination of options 1 and 2

