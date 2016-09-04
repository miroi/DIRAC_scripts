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

