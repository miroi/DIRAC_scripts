=======================
DIRAC performance check
=======================

Implicit  OpenMP  paralelism
----------------------------

benchmark_cc/cc.inp, benchmark_cc/C2H4Cl2_sta_c2h.mol

#mkl - number of OpenMP internal threads of IntelMKL/OpenBLAS library per node (up to 12cpu)

go = GNU OpenBLAS - static:
cc_C2H4Cl2_sta_c2h.out1n_go_omp.1:>>>> Total WALL time used in DIRAC: 19min35s
cc_C2H4Cl2_sta_c2h.out1n_go_omp.6:>>>> Total WALL time used in DIRAC: 14min9s
cc_C2H4Cl2_sta_c2h.out1n_go_omp.12:>>>> Total WALL time used in DIRAC: 14min25s

im = Intel MKL - static:
cc_C2H4Cl2_sta_c2h.out1n_im_omp.1:>>>> Total WALL time used in DIRAC: 17min8s
cc_C2H4Cl2_sta_c2h.out1n_im_omp.6:>>>> Total WALL time used in DIRAC: 10min9s
cc_C2H4Cl2_sta_c2h.out1n_im_omp.12:>>>> Total WALL time used in DIRAC: 9min35s
