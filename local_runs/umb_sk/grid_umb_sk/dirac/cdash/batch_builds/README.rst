==================
PBS build of DIRAC
==================

#40 03 * * 1,2,3,4,5,6,7 DB=/home/milias/Work/qch/software/My_scripts/local_runs/umb_sk/grid_umb_sk/dirac/cdash/batch_builds; cd $DB; git clean -f -x . ;  /usr/bin/qsub $DB/cdash.sivvp_BB.batch 

40 01 * * 1,2,3,4,5,6,7 DB=/home/milias/Work/qch/software/My_scripts/local_runs/umb_sk/grid_umb_sk/dirac/cdash/batch_builds; cd $DB; git clean -f -x . ; git pull;   /usr/bin/qsub $DB/cdash.sivvp_BB.batch 




