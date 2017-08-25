DIRAC hybrid parallelization
============================

Here I present simple performance study of the hybrid  Open MPI - OpenMP parallelization 
of the DIRAC software. 

The **Open MPI** is code's explicit parallelization, while the **OpenMP** is 
implicit parallelization of the linked mathematical library - either MKL or OpenBLAS.

Machine
-------

Peregrine cluster, see https://redmine.hpc.rug.nl/redmine/projects/peregrine/wiki.

- Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz

- 24 cpu node with 125GB memory

System
------

We use DIRAC benchmark Coupled-Cluster test and two different parallel DIRAC installations:

-  Open MPI 2.0.2; Intel-17 with MKL-int8-threaded library

::

  $PAM --mpi=$THISMPI --gb=MEM1 --ag=MEM2  --noarch --inp=$DIRAC/test/benchmark_cc/cc.inp --mol=$DIRAC/test/benchmark_cc/C2H4Cl2_ec2_c2.mol --suffix=i17mkl_mpi$THISMPI-omp$MKL_NUM_THREADS-out

-  Open MPI 2.1.1; Intel-15 with OpenBLAS-int8-threaded library

::

  $PAM --mpi=$THISMPI --gb=MEM1 --ag=MEM2  --noarch --inp=$DIRAC/test/benchmark_cc/cc.inp --mol=$DIRAC/test/benchmark_cc/C2H4Cl2_ec2_c2.mol --suffix=i15openblas_mpi$THISMPI-omp$OPENBLAS_NUM_THREADS-out

The variables MEM1 and MEM2 are to be set carefully with respect to the total node memory and number of OpenMPI-threads.
For instance, for 12 OpenMPI threads MEM2 is max. 120/12=10GB; MEM1 is lower, 8GB.
The higher number of threads, the lower assigned memory per thread.


Results
-------

Wall-times depending on number of OpenMPI (mpi) and OpenMP (mp) threads are shown in the following Table.

TABLE: OpenMPI(mpi) Math-Library-OpenMP(mp) hybrid parallelization performance study.

===  ===  ===============    ===========
mpi  mp   Int15 -OpenBLAS    Intel17-MKL
===  ===  ===============    ===========
4    1     11min39s           10min39s
4    6     10min38s           8min13s 
6    1     10min35s           9min57s
6    4      9min33s           7min53s
12   2      9min11s           8min7s
24   1     10min12s           10min2s
===  ===  ===============    ===========

One can see that better performance is obtained with the Intel17-MKL compilation parameters.
For this testing system, the fastest calculation is with 6 OpenMPI thread, and for each OpenMPI thread there are 4 MKL threads by keeping total number of CPUs,6x4=24.
Higher number of threads may be causing communication overhead and thus performance slowdown.


