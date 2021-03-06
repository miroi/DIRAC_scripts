DIRAC hybrid parallelization
============================

Here I present the simple performance study of the hybrid  Open MPI - OpenMP parallelization 
of the DIRAC relativistic quantum chemistry software, www.diracprogram.org.

The **Open MPI** is code's explicit parallelization, while the **OpenMP** is 
implicit parallelization of the linked mathematical library - either MKL or OpenBLAS.

Machine
-------

We employed the Kronos cluster, see https://wiki.gsi.de/foswiki/bin/view/Linux/SlurmUsage?redirectedfrom=Linux.KronosUsage .

The SLURM system chose the working node:

- Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz

- 57 CPU node with 126 GB of the total memory (checked via free -g -t)

System
------

We use DIRAC benchmark Coupled-Cluster test and two different parallel DIRAC installations.
Both consist of the Open MPI framework, the Intel compiler enhanced with highest optimization flag, *-xHost*, 
and internally threaded mathematical library - open OpenBLAS and commercial MKL.

-  Open MPI 2.0.1; Intel-17 with MKL-integer8 internally-threaded(OpenMP) library

::

    $PAM1  --mpi=$nOpenMPI  --gb=4.60  --ag=5.00  --noarch --inp=$DIRAC/test/benchmark_cc/cc.inp --mol=$DIRAC/test/benchmark_cc/C2H4Cl2_sta_c1.mol --suffix=i17mkl-mpi$nOpenMPI-omp$MKL_NUM_THREADS-tmp_out

-  Open MPI 2.0.1; Intel-17 with OpenBLAS-integer8 internally-threaded(OpenMP) library

::

    $PAM2  --mpi=$nOpenMPI  --gb=4.60  --ag=5.00  --noarch --inp=$DIRAC/test/benchmark_cc/cc.inp --mol=$DIRAC/test/benchmark_cc/C2H4Cl2_sta_c1.mol --suffix=i17oblas-mpi$nOpenMPI-omp$OPENBLAS_NUM_THREADS-tmp_out


The variables --gb=MEM1 and --ag=MEM2 are to be set carefully with respect to the total node memory and number of OpenMPI-threads.
For instance, for 24 OpenMPI threads MEM2 is max. 120/24=5GB; MEM1 is to be lower, 4.60GB.
The higher number of threads, the lower assigned memory per thread. 
We have to be carefull to set the suitable value of MEM2 to make the memory demanding job pass.


Results
-------

Wall times depending on number of OpenMPI (mpi) and OpenMP (omp) threads are shown in the following Table:

.. _mytable:
.. table:: Hybrid OpenMPI(mpi) & OpenMP(omp) calculations performances

  ===  ===  ================    ===========
  mpi  omp  OpenBLAS-global     MKL-global
  ===  ===  ================    ===========
  2    12    25min4s            24min0s
  24   1     10min12s           10min2s
  ===  ===  ================    ===========

Discussion
----------

One can see (in Table :ref:`mytable`) that better performance is obtained with the Intel17-MKL compilation settings.

For this testing system, the fastest calculation is with 6 OpenMPI threads,
where for each mpi-thread there are 4 MKL omp threads by keeping total number of CPUs,6x4=24.

Higher number of threads may be causing communication overhead and thus performance slowdown,
as we see for 12 and 24 mpi-threads. 

However, more testing calculation are to be done for more definitive conclusion.

