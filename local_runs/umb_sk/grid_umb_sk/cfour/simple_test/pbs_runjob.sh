#!/bin/sh
##
##   Written by Jonas Juselius <jonas@iki.fi>
##   extended by Michael Harding <harding@uni-mainz.de> 
##

###-------- PBS parameters ----------
#PBS -o run.out -e qsub.out
#PBS -q itanium
#PBS -lnodes=2
#PBS -lwalltime=00:10:00
#PBS -lpmem=300MB
##PBS -m abe
###-------- end PBS parameters ----------

#CFOUR=/scrcluster/harding/aces2.par
CFOUR=home/milias/Work/qch/software/cfour
QUESYS=$CFOUR/share/quesys.sh

if [ -f $QUESYS ]; then
    .   $QUESYS
else
    echo "$QUESYS not found!"
    exit 1
fi

# if NOTIFY is set an e-mail notification is sent to that adress at the start
# and end of the job
NOTIFY=

###------ JOB SPECIFIC ENVIRONMENT --###

#export P4_GLOBMEMSIZE=120000000
#export PATH=/tc/tcusers/harding/qtest:$PATH
#LAMRSH="ssh -x"; export LAMRSH
#export OMP_NUM_THREADS=4
PATH=".:$PATH:$CFOUR/bin"
###------ JOB SPECIFIC DEFNITIONS ------###


#stop_on_crash=no
# possible jobs types are: mpich, lam, scali, mvapich or serial
jobtype="serial" 

# a job id is automatically added to the workdir
#workdir=/scr/$USER 
workdir=/scr/$USER 
global_workdisk=no
outdir=out

###--- JOB SPECIFICATION ---###
input="ZMAT $CFOUR/basis/GENBAS $CFOUR/bin/x*"
initialize_job

# distribute input files to all nodes
distribute $input

# exenodes executes non MPI commands on every node. If the '-all' flag is
# given it will execute the command for every allocated CPU on every node.
#exenodes mycomand files foobar

# run job either in parallel (if appropriate)
#run xcfour.sh 
cd $workdir
xcfour


# gather files from all nodes. gather accepts the follwing flags:
#  -tag      append the nodename to every file 
#  -maxsize  maximum size (kB) of files to copy back
gather -maxsize 10000

finalize_job
###------ END  ------###
# vim:syntax=sh:filetype=sh
