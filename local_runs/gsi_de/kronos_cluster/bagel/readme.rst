BAGEL on Kronos cluster
=======================

Do impi...

milias@lxbk0198.gsi.de:/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/../configure --prefix=/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/build_intelmpi19mkl  --with-boost-libdir=/usr/lib/x86_64-linux-gnu  --with-mpi=intel --enable-mkl

milias@lxbk0198.gsi.de:/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/.CC=icc CXX=icpc MPICC=mpiicc MPICXX=mpiicpc  ./configure --prefix=/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/build_intelmpi19mkl   --with-boost-libdir=/usr/lib/x86_64-linux-gnu  --with-mpi=intel  --enable-mkl

does not work:
milias@lxbk0198.gsi.de:/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/.CC=icc CXX=icpc MPICC=mpiicc MPICXX=mpiicpc  ./configure --prefix=/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/build_intelmpi19mkl   --with-boost-libdir=/usr/lib/x86_64-linux-gnu  --with-boost-regex=/usr/lib/x86_64-linux-gnu/libboost_regex.a  --with-mpi=intel  --enable-mkl 

milias@lxbk0198.gsi.de:/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/.MPICC=mpiicc MPICXX=mpiicpc  ./configure --prefix=/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/build_intelmpi19mkl   --with-boost-libdir=/usr/lib/x86_64-linux-gnu    --with-mpi=intel  --enable-mkl    


THIS works:

./configure --prefix=/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/build_intelmpi19mkl   --with-boost-libdir=/usr/lib/x86_64-linux-gnu  --with-mpi=intel  --enable-mkl


Alto this works:

milias@lxbk0198.gsi.de:/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/.CC=icc CXX=icpc  ./configure --prefix=/lustre/nyx/ukt/milias/work/software/bagel/bagel_master/build_intelmpi19mkl   --with-boost-libdir=/usr/lib/x86_64-linux-gnu    --with-mpi=intel  --enable-mkl 



MVAPICH:
-------
#  /compiler/intel/17.4

#  milias@lxbk0198.gsi.de:/lustre/nyx/ukt/milias/bin/mvapich/mvapich2-2.3.1/.FC=ifort CC=icc CXX=icpc ./configure  --prefix=/lustre/nyx/ukt/milias/bin/mvapich --disable-mcast  

#  due to configure: error: 'infiniband/mad.h not found. Please retry with --disable-mcast'








