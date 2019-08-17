==================
BAGEL on peregrine
==================

# Load modules
  module load CMake/3.12.1-GCCcore-7.3.0
  module load intel/2019a  # Intel compilers, Intel MPI and MKL
  module load Boost/1.67.0-foss-2018a
  module unload OpenMPI/2.1.2-GCC-6.4.0-2.28

  echo -e "\n Loaded modules:"; module list
f113112@peregrine.hpc.rug.nl:~/work/qch/software/bagel_suite/bagel_master/.CC=icc CXX=icpc ./configure --prefix=/home/f113112/work/qch/software/bagel_suite/bagel_master --enable-mkl --with-mpi=intel


Compilation via BATCH
---------------------



