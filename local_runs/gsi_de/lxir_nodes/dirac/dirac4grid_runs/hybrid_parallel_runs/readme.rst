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

