#!/bin/csh
#BSUB -W 0:03 		   # Maximum 5min
#BSUB -J s2p               # Job name as listed in queue	
#BSUB -n 8 		   # number of MPI processes
#BSUB -R span[ptile=2]     # put on different nodes to test MPI
#BSUB -oo s2p_R_out   # Write stdout to file s2p_out, overwrite old ones
#BSUB -eo s2p_R_err   # Write stdout to file s2p_err, overwrite old ones
setenv TMPDIR /scratch/$LSB_JOBID
mkdir -p /scratch/$LSB_JOBID
module load openmpi-gcc/openmpi4.0.0-gcc4.8.5
module load R 
mpirun ./s2p 
rm -fr /scratch/$LSB_JOBID
