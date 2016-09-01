======================================
CFOUR on ilias@login-sivvp.ui.savba.sk
======================================

MKL linking accrding to https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor

ilias@login-sivvp.ui.savba.sk:/shared/home/ilias/Work/software/cfour/cfour_v2.00beta/.FC=ifort CC=icc CXX=icpc ./configure --with-blas="${MKLROOT}/lib/intel64/libmkl_blas95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl " --with-lapack=" ${MKLROOT}/lib/intel64/libmkl_lapack95_ilp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -openmp -lpthread -lm -ldl "  --prefix=/shared/home/ilias/Work/software/cfour/cfour_v2.00beta/build/intel_mklpar_i8 

make -j8 install



