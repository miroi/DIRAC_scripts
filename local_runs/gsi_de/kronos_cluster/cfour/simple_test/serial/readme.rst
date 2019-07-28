================
CFOUR serial run
================

Currently Loaded Modulefiles:
  1) /compiler/intel/17.4

milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_intel-serial/.echo $MKLROOT
/cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl

milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_intel-serial/.FC=ifort CC=icc CXX=icpc ./configure --prefix=$PWD --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl"

  make -j32















