CFOUR on Kronos cluster
=======================

$ ./configure --prefix=/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_openmpi_intel --with-blas=/cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group /cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_intel_ilp64.a /cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_core.a /cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl --with-lapack=/cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group /cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_intel_ilp64.a /cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_core.a  /cvmfs/it.gsi.de/compiler/intel/17.0/compilers_and_libraries_2017.4.196/linux/mkl/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl --enable-mpi=openmpi --with-mpirun=mpirun -np $CFOUR_NUM_CORES --with-exenodes=mpirun -np $CFOUR_NUM_CORES


milias@lxbk0196.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour-public_v2.1_openmpi_intel/.






