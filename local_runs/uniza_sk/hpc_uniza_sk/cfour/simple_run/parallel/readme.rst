CFOUR parallel 
==============

umbilias@login.hpc.uniza.sk:/work/umbilias/work/software/cfour/cfour_v2.1_openmpi1.8.4_Intel14/cfour-public-master/.module list
Currently Loaded Modulefiles:
  1) intel/composerxe_2013   2) boost/1.57              3) Python/3.3.6            4) openmpi/1.8.4-i         5) devtools/2

umbilias@login.hpc.uniza.sk:/work/umbilias/work/runs/My_scripts/local_runs/uniza_sk/hpc_uniza_sk/cfour/.mpirun --version
mpirun (Open MPI) 1.8.4

Report bugs to http://www.open-mpi.org/community/help/
umbilias@login.hpc.uniza.sk:/work/umbilias/work/runs/My_scripts/local_runs/uniza_sk/hpc_uniza_sk/cfour/.mpif90 --version
ifort (IFORT) 14.0.3 20140422
Copyright (C) 1985-2014 Intel Corporation.  All rights reserved.

g++ --version
g++ (GCC) 4.8.2 20140120 (Red Hat 4.8.2-15)
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


umbilias@login.hpc.uniza.sk:/work/umbilias/work/software/cfour/cfour_v2.1_openmpi1.8.4_Intel14/cfour-public-master/.LDFLAGS="-openmp -lpthread" FC=ifort CC=icc CXX=g++  MPIFC=mpif90 ./configure --prefix=$PWD --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --enable-mpi=openmpi --with-mpirun="mpirun -np \$CFOUR_NUM_CORES" --with-exenodes="mpirun -np \$CFOUR_NUM_CORES"

