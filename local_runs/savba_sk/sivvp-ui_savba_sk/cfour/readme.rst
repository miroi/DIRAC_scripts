======================================
CFOUR on ilias@login-sivvp.ui.savba.sk
======================================

Serial Intel-MKL-i8
~~~~~~~~~~~~~~~~~~~

MKL linking accrding to https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor

ilias@login-sivvp.ui.savba.sk:/shared/home/ilias/Work/software/cfour/cfour_v2.00beta/.FC=ifort CC=icc CXX=icpc ./configure --with-blas="${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl " --with-lapack=" ${MKLROOT}/lib/intel64/libmkl_lapack95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl "  --prefix=/shared/home/ilias/Work/software/cfour/cfour_v2.00beta/build/intel_mklpar_i8 

make -j8 install


Parallel Intel-MKL-i8
~~~~~~~~~~~~~~~~~~~~~

needs MKL initialization of $MKLROOT

FC=ifort CC=icc MPIFC=mpif90 configure --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --prefix=/lustre/nyx/ukt/milias/work/software/cfour/multiple_installations/builds/openmpi2.0.1-intel17-mkl --enable-mpi=openmpi --with-mpirun="mpirun -np \$CFOUR_NUM_CORES" --with-exenodes="mpirun -np \$CFOUR_NUM_CORES"

