===========
CFour suite
===========

source $MKLROOT/bin/mklvars.sh ...

milias@login.grid.umb.sk:~/Work/qch/software/cfour/cfour_v2.00beta/.FC=ifort CC=icc CXX=icpc ./configure --with-blas=" ${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl " --with-lapack=" ${MKLROOT}/lib/intel64/libmkl_lapack95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl "  --prefix=/home/milias/Work/qch/software/cfour/cfour_v2.00beta/build/intelmklpar

make -j2 install



