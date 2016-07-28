===================================
DIRAC4Grid tests on lxir* GSI nodes
====================================

1 node check  OpenMPI and  MKL's OpenMP hybrid parallelizations 
---------------------------------------------------------------

 test/cc_linear

 #np   #mkl    time
  1     1    0m6.621s
  1     2    0m5.696s
  1     4    0m5.729s
  1     8    0m5.718s

  2     1    0m5.722s
  2     2    0m5.774s
  2     4    0m6.288s

  4     1    0m6.308s
  4     2    0m5.823s

  8     1    0m5.706s


milias@lxir073.gsi.de:~/Work/qch/software/dirac/My_scripts/local_runs/gsi_de/lxir_nodes/dirac/dirac4grid_runs/hybrid_parallel_runs/.grep "Total WALL time used in DIRAC" *
readme.rst:cc_N2.ccpVTZ.out_p-go.1-1:>>>> Total WALL time used in DIRAC: 1min3s
readme.rst:cc_N2.ccpVTZ.out_p-go.1-2:>>>> Total WALL time used in DIRAC: 1min5s
readme.rst:cc_N2.ccpVTZ.out_p-go.1-4:>>>> Total WALL time used in DIRAC: 1min9s
readme.rst:cc_N2.ccpVTZ.out_p-go.1-8:>>>> Total WALL time used in DIRAC: 1min7s

readme.rst:cc_N2.ccpVTZ.out_p-go.2-1:>>>> Total WALL time used in DIRAC: 50s
readme.rst:cc_N2.ccpVTZ.out_p-go.2-2:>>>> Total WALL time used in DIRAC: 51s
readme.rst:cc_N2.ccpVTZ.out_p-go.2-4:>>>> Total WALL time used in DIRAC: 56s

readme.rst:cc_N2.ccpVTZ.out_p-go.4-1:>>>> Total WALL time used in DIRAC: 34s
readme.rst:cc_N2.ccpVTZ.out_p-go.4-2:>>>> Total WALL time used in DIRAC: 34s

readme.rst:cc_N2.ccpVTZ.out_p-go.8-1:>>>> Total WALL time used in DIRAC: 1min21s


readme.rst:cc_N2.ccpVTZ.out_p-im.1-1:>>>> Total WALL time used in DIRAC: 46s
readme.rst:cc_N2.ccpVTZ.out_p-im.1-2:>>>> Total WALL time used in DIRAC: 47s
readme.rst:cc_N2.ccpVTZ.out_p-im.1-4:>>>> Total WALL time used in DIRAC: 47s
readme.rst:cc_N2.ccpVTZ.out_p-im.1-8:>>>> Total WALL time used in DIRAC: 48s

readme.rst:cc_N2.ccpVTZ.out_p-im.2-1:>>>> Total WALL time used in DIRAC: 43s
readme.rst:cc_N2.ccpVTZ.out_p-im.2-2:>>>> Total WALL time used in DIRAC: 44s
readme.rst:cc_N2.ccpVTZ.out_p-im.2-4:>>>> Total WALL time used in DIRAC: 44s

readme.rst:cc_N2.ccpVTZ.out_p-im.4-1:>>>> Total WALL time used in DIRAC: 28s
readme.rst:cc_N2.ccpVTZ.out_p-im.4-2:>>>> Total WALL time used in DIRAC: 28s

readme.rst:cc_N2.ccpVTZ.out_p-im.8-1:>>>> Total WALL time used in DIRAC: 1min18s


Pure OpenMP-threaded run (MKL and OpenBLAS)
-------------------------------------------
milias@lxir073.gsi.de:~/Work/qch/software/dirac/My_scripts/local_runs/gsi_de/lxir_nodes/dirac/dirac4grid_runs/hybrid_parallel_runs/.grep "Total WALL time used in DIRAC"  *.out*
cc_N2.ccpVTZ.out_go.1:>>>> Total WALL time used in DIRAC: 45s
cc_N2.ccpVTZ.out_go.2:>>>> Total WALL time used in DIRAC: 47s
cc_N2.ccpVTZ.out_go.4:>>>> Total WALL time used in DIRAC: 45s
cc_N2.ccpVTZ.out_im.1:>>>> Total WALL time used in DIRAC: 1min3s
cc_N2.ccpVTZ.out_im.2:>>>> Total WALL time used in DIRAC: 1min4s
cc_N2.ccpVTZ.out_im.4:>>>> Total WALL time used in DIRAC: 1min3s
cc_N2.ccpVTZ.out_im.8:>>>> Total WALL time used in DIRAC: 1min7s





