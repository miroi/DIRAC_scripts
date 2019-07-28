================
CFOUR serial run
================

Currently Loaded Modulefiles:
  1) /compiler/intel/17.4

  /lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_intel-serial

  milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_intel-serial/.FC=ifort CC=icc CXX=icpc ./configure --with-blas="$MKLROOT/libmkl_solver_ilp64.a -Wl,--start-group $MKLROOT/libmkl_intel_ilp64.a $MKLROOT/libmkl_intel_thread.a $MKROOT/libmkl_core.a -Wl,--end-group -openmp -lpthread" --prefix=$PWD

  milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_intel-serial/.FC=ifort CC=icc CXX=icpc ./configure --with-blas="-mkl" --with-lapack="-mkl" --prefix=$PWD ... rather this

  make -j24















