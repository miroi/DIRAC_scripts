CFOUR on Kronos cluster
=======================

milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_openmpi_intel/.

Currently Loaded Modulefiles:
  1) /compiler/intel/17.4           2) /ucx/intel/1.5_intel17.4       3) /openmpi/intel/4.0_intel17.4

milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_openmpi_intel/.FC=ifort CC=icc CXX=icpc  MPIFC=mpif90 MPICC=mpicc MPICXX=mpicxx  ./configure --prefix=$PWD --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --enable-mpi=openmpi --with-mpirun="mpirun -np \$CFOUR_NUM_CORES" --with-exenodes="mpirun -np \$CFOUR_NUM_CORES"

 make clean; make -j32


