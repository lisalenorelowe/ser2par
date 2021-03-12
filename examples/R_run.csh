#!/bin/csh
#BSUB -W 0:05 		   # Maximum 5min
#BSUB -J ser2par              # Job name as listed in queue	
#BSUB -n 8 		   # number of MPI processes
#BSUB -oo s2p_R_out   # Write stdout to file s2p_out, overwrite old ones
#BSUB -eo s2p_R_err   # Write stdout to file s2p_err, overwrite old ones
module load PrgEnv-intel 
module load R 
mpirun ./ser2par
