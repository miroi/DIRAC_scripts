=======================
DIRAC performance check
=======================

Implicit MKL's OpenMP  paralelism
---------------------------------

time1: benchmark_cc/cc.inp, benchmark_cc/C2H4Cl2_sta_c2h.mol
time2: benchmark_cc_linear/cc.inp, benchmark_cc_linear/N2.ccpVQZ.mol

#mkl - number of OpenMP internal threads of IntelMKL library per node (up to 12cpu)

  #mkl     time1     time2
----------------------------
   1      17min14s   5min46s
   6      10min10s   5min44s
  12      9min46s    6min5s 
