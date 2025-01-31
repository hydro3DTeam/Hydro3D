#!/bin/bash

cpu=7
subdomains=42
delta=0.01
itime=10
etime=1360
dtime=10
nprocs=80
Smax=0
filename='input_file.txt'

# Run_simulation:
mpirun -np $cpu ./3dFDM_2023.exe

# Computational result:
cp rms.dat worktime.dat output.dat forcn*.dat *.cin LPT_*.dat Results 

# Write input file for postprocess:
echo "$delta,$Smax" > "$filename"
echo "$itime,$etime,$dtime" >> "$filename"
echo "$nprocs" >> "$filename"

# Run_post_processing:
cp ../PostProcessing_Script/subdomMerge_*.f90 .
ifort -traceback -qopenmp -parallel -fpp subdomMerge_tecinst_OpenMP_Scalar.f90 -o subdomMerge_tecinst_OpenMP_Scalar.exe
./subdomMerge_tecinst_OpenMP_Scalar.exe 

ifort -traceback -qopenmp -parallel -fpp subdomMerge_preplot_OpenMP.f90 -o subdomMerge_preplot_OpenMP.exe
./subdomMerge_preplot_OpenMP.exe

# Delete input file:
rm $filename
rm subdomMerge_tecinst_OpenMP_Scalar.* subdomMerge_preplot_OpenMP.*
rm full*.dat tecinst*

