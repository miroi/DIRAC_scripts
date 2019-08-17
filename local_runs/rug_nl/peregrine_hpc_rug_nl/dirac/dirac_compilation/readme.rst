======================================
DIRAC compilation on peregrine cluster
======================================

with Intel-MPI

module unload OpenMPI/2.1.2-GCC-6.4.0-2.28

DIRAC=/home/f113112/work/qch/software/dirac/devel_trunk

f113112@peregrine.hpc.rug.nl:~/work/qch/software/dirac/devel_trunk/.

./setup --mpi --fc=mpiifort --cc=mpiicc --cxx=mpiicpc --mkl=parallel  --int64  build_intelmpi_mklpar_i8








