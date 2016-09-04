===================================
DIRAC buildups for Grid environment
===================================

- crontab prescription for grid.ui.savba.sk:

::

 05 00 * * 1,2,3,4,5,6,7 SCRIPTS=/scratch/milias/Work/qch/software/My_scripts/local_runs/savba_sk/grid_ui_savba_sk/dirac4grid_buildups;   $SCRIPTS/grid_ui_savba_sk_buildup.bash  >  $SCRIPTS/grid_ui_savba_sk_buildup.log 2>&1

- only static buildups
- both OpenMPI and serial
- both MKL-library and OpenBLAS library for buildups
