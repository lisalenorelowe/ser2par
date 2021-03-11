module load openmpi-gcc/openmpi4.0.0-gcc4.8.5
mpif90 -o ser2par -Ddebug -g -fcheck=all -Wall s2p.F90
