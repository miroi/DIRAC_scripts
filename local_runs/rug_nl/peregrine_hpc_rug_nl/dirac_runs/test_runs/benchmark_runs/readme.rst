DIRAC hybrid parallelization
============================

Here I present simple performance study of the hybrid  Open MPI - OpenMP parallelization 
of the DIRAC software. Open MPI is explicit code parallelization, while OpenMP is 
implicit parallelization of the linked mathematical library - either MKL or OpenBLAS, both with Integer*8 support.

Machine
-------

Peregrine cluster; https://redmine.hpc.rug.nl/redmine/projects/peregrine/wiki
- Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz
- 24 cpu node with 125GB memory

System
------

We use DIRAC benchmark Coupled-Cluster test and two different parallel DIRAC installations.

-  Open MPI 2.0.2; Intel-17 with MKL-threaded library:

::

  $PAM --mpi=$THISMPI --gb=MEM1 --ag=MEM2  --noarch --inp=$DIRAC/test/benchmark_cc/cc.inp --mol=$DIRAC/test/benchmark_cc/C2H4Cl2_ec2_c2.mol --suffix=i17mkl_mpi$THISMPI-omp$MKL_NUM_THREADS-out

-  Open MPI 2.1.1; Intel-15 with OpenBLAS-threaded library:

::

  $PAM --mpi=$THISMPI --gb=MEM1 --ag=MEM2  --noarch --inp=$DIRAC/test/benchmark_cc/cc.inp --mol=$DIRAC/test/benchmark_cc/C2H4Cl2_ec2_c2.mol --suffix=i15openblas_mpi$THISMPI-omp$OPENBLAS_NUM_THREADS-out

The variables MEM1 and MEM2 are to be set carefully with respect to the total node memory and number of OpenMPI-threads. For instance, for 12 threads
the MEM2 is max. 120/12=10GB. MEM1 is lower, 8GB. 


Results
-------

Wall-times depending on number of OpenMPI (mpi) and OpenMP (mp) threads are shown in the following Table.

TABLE: OpenMPI(mpi) Math-Library-OpenMP(mp) hybrid parallelization performance study.

=== ===  ===============    ===========
mpi  mp  Int15-OpenBLAS     Intel17-MKL
=== ===  ===============    ===========
4    1     11min39s           10min39s
4    6     10min38s           8min13s 
6    1     10min35s           9min57s
6    4      9min33s           7min53s
12   2      9min11s           ....
24   1     10min12s           10min2s
=== ===  ===============    ===========


