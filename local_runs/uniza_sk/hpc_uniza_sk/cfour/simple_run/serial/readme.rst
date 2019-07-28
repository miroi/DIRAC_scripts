CFOUR v2.1 serial
=================

umbilias@login.hpc.uniza.sk:/work/umbilias/work/software/cfour/cfour_v2.1_Intel14_serial/cfour-public-master/.module list
Currently Loaded Modulefiles:
  1) intel/composerxe_2013   2) boost/1.57              3) Python/3.3.6            4) openmpi/1.8.4-i         5) devtools/2

umbilias@login.hpc.uniza.sk:/work/umbilias/work/software/cfour/cfour_v2.1_Intel14_serial/cfour-public-master/.g++ --version
g++ (GCC) 4.8.2 20140120 (Red Hat 4.8.2-15)

FC=ifort CC=icc CXX=g++  ./configure --prefix=$PWD --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" 

