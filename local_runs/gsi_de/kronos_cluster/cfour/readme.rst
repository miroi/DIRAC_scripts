
Intel MKL 11.2, 
Intel 15


milias@lxbk0199.gsi.de:/lustre/nyx/ukt/milias/work/software/cfour/cfour_v2.00beta/.FC=ifort CC=icc CXX=g++ ./configure --with-blas=" ${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl"  --with-lapack=" ${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl "  --prefix=$PWD/build/intelmklpar_i8

