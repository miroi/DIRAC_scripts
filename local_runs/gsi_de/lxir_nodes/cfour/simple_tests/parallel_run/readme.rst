CFOUR on lxir127.gsi.de
=======================

Cloning:
--------
 git clone git@cfour.chem.ufl.edu:cfour-public/cfour-public.git cfour-public_openmpi_intel

Configure and build:
--------------------

::
 module list
 Currently Loaded Modulefiles:
  1) /compiler/intel/17.4           2) /ucx/intel/1.5_intel17.4       3) /openmpi/intel/4.0_intel17.4
 milias@lxir127.gsi.de:/tmp/milias-dirac-software/cfour/cfour-public_openmpi_intel/.

::
 milias@lxir127.gsi.de:/tmp/milias-dirac-software/cfour/cfour-public_openmpi_intel/.FC=ifort CC=icc MPIFC=mpif90 ./configure --prefix=$PWD --with-blas="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --with-lapack="$MKLROOT/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group $MKLROOT/lib/intel64/libmkl_intel_ilp64.a $MKLROOT/lib/intel64/libmkl_core.a  $MKLROOT/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl" --enable-mpi=openmpi --with-mpirun="mpirun -np \$CFOUR_NUM_CORES" --with-exenodes="mpirun -np \$CFOUR_NUM_CORES"

::
 make -j12 all install

