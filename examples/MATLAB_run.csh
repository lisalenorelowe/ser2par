#!/bin/csh
#BSUB -W 0:05 		   # Maximum 5min
#BSUB -J ser2par               # Job name as listed in queue	
#BSUB -n 8 		   # number of MPI processes
#BSUB -oo s2p_matlab_out   # Write stdout to file s2p_out, overwrite old ones
#BSUB -eo s2p_matlab_err   # Write stdout to file s2p_err, overwrite old ones
setenv TMPDIR /scratch/$LSB_JOBID
mkdir -p /scratch/$LSB_JOBID
module load openmpi-gcc/openmpi4.0.0-gcc4.8.5
module load matlab
mpirun ./ser2par
rm -fr /scratch/$LSB_JOBID
