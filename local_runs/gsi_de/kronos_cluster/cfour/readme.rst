==============
CFOUR buildups
==============

Intel 15, MKL 11.2
~~~~~~~~~~~~~~~~~~

milias@lxbk0199.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour_v2.00beta/.FC=ifort CC=icc CXX=g++ ./configure --with-blas=" ${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl"  --with-lapack=" ${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl "  --prefix=$PWD/build/intelmklpar_i8

Intel-17, OpenMPI-2-Intel17
~~~~~~~~~~~~~~~~~~~~~~~~~~~
milias@lxbk0200.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/multiple_installations/builds/cfour_v2.00beta/.FC=ifort CC=icc MPIFC=mpif90 ../../src/cfour_v2.00beta/configure --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --prefix=/lustre/nyx/ukt/milias/work/software/cfour/multiple_installations/builds/openmpi2.0.1-intel17-mkl --enable-mpi=openmpi --with-mpirun="mpirun -np \$CFOUR_NUM_CORES" --with-exenodes="mpirun -np \$CFOUR_NUM_CORES"

preferred installation
~~~~~~~~~~~~~~~~~~~~~~
milias@lxbk0200.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour_v2.00beta_opempi-2.0.1-inte17/.FC=ifort CC=icc MPIFC=mpif90  configure --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --prefix=/lustre/nyx/ukt/milias/work/software/cfour/multiple_installations/builds/openmpi2.0.1-intel17-mkl --enable-mpi=openmpi --with-mpirun="mpirun -np \$CFOUR_NUM_CORES" --with-exenodes="mpirun -np \$CFOUR_NUM_CORES"

make -j12 install

