#!/bin/tcsh
#BSUB -J s2p[1-4]   #job name AND job array
#BSUB -n 4                #number of cores
#BSUB -W 00:10            #walltime limit: hh:mm
#BSUB -o s2p_%J_%I.out #output - %J is the job-id %I is the job-array index
#BSUB -e s2p_%J_%I.err  #error - %J is the job-id %I is the job-array index 
setenv TMPDIR /scratch/$LSB_JOBID/$LSB_JOBINDEX
mkdir -p /scratch/$LSB_JOBID/$LSB_JOBINDEX
module load openmpi-gcc/openmpi4.0.0-gcc4.8.5
module load R
@ skip = $LSB_JOBINDEX - 1
@ skip = $skip * 4
mpirun ./ser2par $skip
rm -fr /scratch/$LSB_JOBID/$LSB_JOBINDEX
