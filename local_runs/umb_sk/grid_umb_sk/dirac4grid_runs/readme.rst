=======================
DIRAC performance check
=======================

Implicit MKL's OpenMP  paralelism
---------------------------------

time1: benchmark_cc/cc.inp, benchmark_cc/C2H4Cl2_sta_c2h.mol

#np - number of OpenMPi tasks (up to 12cpu)
#mkl - number of OpenMP internal threads of IntelMKL library per node (up to 12cpu)

#np  #mkl     
-------------------
1     1      
1     6      
1    12     
