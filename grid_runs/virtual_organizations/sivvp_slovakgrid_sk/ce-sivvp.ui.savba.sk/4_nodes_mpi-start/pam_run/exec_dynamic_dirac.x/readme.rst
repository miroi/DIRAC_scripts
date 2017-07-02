======================
4 nodes, mpi-start run
======================

mpi-start with the dynamic dirac.x (from ilias@login-sivvp.ui.savba.sk)  in the shared disk space

The dynamical "dirac.x" is downloaded from SE, together with Dirac4Grid package.

In the created directory on CE=login-sivvp.ui.savba.sk, dirac.x is launched with DIRAC.INP and MOLECULE.MOL files.

1315710.batch.sivvp     sivvp082    sivvp    cream_885841053    6702     4     48    --  4000:00:0 R  00:04:13
   comp22/0+comp22/1+comp22/2+comp22/3+comp22/4+comp22/5+comp22/6+comp22/7
   +comp22/8+comp22/9+comp22/10+comp22/11+comp33/0+comp33/1+comp33/2+comp33/3
   +comp33/4+comp33/5+comp33/6+comp33/7+comp33/8+comp33/9+comp33/10+comp33/11
   +comp34/0+comp34/1+comp34/2+comp34/3+comp34/4+comp34/5+comp34/6+comp34/7
   +comp34/8+comp34/9+comp34/10+comp34/11+comp35/0+comp35/1+comp35/2+comp35/3
   +comp35/4+comp35/5+comp35/6+comp35/7+comp35/8+comp35/9+comp35/10+comp35/11

Server's mpirun works with dynamic dirac.x on 4 nodes !

Own static dirac.x with own static mpirun is crashing ...

Own static dirac.x with server's dynamic mpirun is crashing ...


==========
THIS WORKS
==========

  Another OpenMPI parallel run .... which mpirun .../shared/software/openmpi/1.8.3-intel/bin/mpirun
mpirun -H comp22,comp30,comp31,comp32 -npernode 2 -x PATH -x LD_LIBRARY_PATH ...

  ** notice ** integer kinds do not match: dirac --> kind = 8 MPI library --> kind =  4
  ** interface to 32-bit integer MPI enabled **

DIRAC master    (comp22) starts by allocating             64000000 words (           488 MB) of memory
DIRAC node    1 (comp22) starts by allocating             64000000 words (           488 MB) of memory
DIRAC node    4 (comp31) starts by allocating             64000000 words (           488 MB) of memory
DIRAC node    5 (comp31) starts by allocating             64000000 words (           488 MB) of memory
DIRAC master    (comp22) to allocate at most            2147483648 words (         16384 MB) of memory
 
Note: maximum allocatable memory for master+nodes can be set by -aw flag (MW) in pam
 
DIRAC node    1 (comp22) to allocate at most            2147483648 words (         16384 MB) of memory
DIRAC node    6 (comp32) starts by allocating             64000000 words (           488 MB) of memory
DIRAC node    7 (comp32) starts by allocating             64000000 words (           488 MB) of memory
DIRAC node    5 (comp31) to allocate at most            2147483648 words (         16384 MB) of memory
DIRAC node    4 (comp31) to allocate at most            2147483648 words (         16384 MB) of memory
DIRAC node    6 (comp32) to allocate at most            2147483648 words (         16384 MB) of memory
DIRAC node    7 (comp32) to allocate at most            2147483648 words (         16384 MB) of memory
 *******************************************************************************
 *                                                                             *
 *                                O U T P U T                                  *
 *                                   from                                      *

