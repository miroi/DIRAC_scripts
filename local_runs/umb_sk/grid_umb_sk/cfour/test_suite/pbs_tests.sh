#!/bin/sh
##
##   Written by Jonas Juselius <jonas@iki.fi>
##   extended by Michael Harding <harding@uni-mainz.de> 
##

#PBS -S /bin/bash
#PBS -A UMB-ITMS-26110230082
#PBS -N C4_tests
### Declare myprogram non-rerunable
#PBS -r n
##PBS -l nodes=1:ppn=12:old
#PBS -l nodes=1:ppn=4
#PBS -l walltime=20:00:00
##PBS -l mem=47g
#PBS -l mem=16g
#PBS -j oe
#PBS -q batch

echo "Working host is: "; hostname -f
source /mnt/apps/intel/bin/compilervars.sh intel64
source /mnt/apps/pgi/environment.sh

# libnumma for PGI
export LD_LIBRARY_PATH=/home/milias/bin/lib64_libnuma:$LD_LIBRARY_PATH

echo "My PATH=$PATH"
echo "Running on host `hostname`"
echo "Time is `date`"
echo "Directory is `pwd`"
echo "This jobs runs on the following processors:"
echo `cat $PBS_NODEFILE`
# Extract number of processors
NPROCS_PBS=`wc -l < $PBS_NODEFILE`
NPROCS=`cat /proc/cpuinfo | grep processor | wc -l`
echo "This node has $NPROCS CPUs."
echo "This node has $NPROCS_PBS CPUs allocated for PBS calculations."
echo "PBS_SERVER=$PBS_SERVER"
echo "PBS_NODEFILE=$PBS_NODEFILE"
echo "PBS_O_QUEUE=$PBS_O_QUEUE"
echo "PBS_O_WORKDIR=$PBS_O_WORKDIR"
# ...
export MKL_NUM_THREADS=$NPROCS_PBS
echo "MKL_NUM_THREADS=$MKL_NUM_THREADS"
#export MKL_DOMAIN_NUM_THREADS="MKL_BLAS=$NPROCS"
export OMP_NUM_THREADS=1
export MKL_DYNAMIC="FALSE"
export OMP_DYNAMIC="FALSE"


#CFOUR=/scrcluster/harding/aces2.par
CFOUR=/home/milias/Work/qch/software/cfour/cfour_v2.00beta
CFOURBUILD=$CFOUR/build/intelmklpar
QUESYS=$CFOUR/share/quesys.sh

if [ -f $QUESYS ]; then
    .   $QUESYS
else
    echo "$QUESYS not found!"
    exit 1
fi

jobtype="serial" 
# a job id is automatically added to the workdir
workdir=/mnt/local/$USER/$PBS_JOBID

cd $workdir
cp -R $CFOUR/testsuite .
cp -R $CFOURBUILD  .
ls -lt

PATH=".:$PATH:$PWD/intelmkl/bin"
echo -e "PATH=$PATH"

#xtester --whatistested
xtester --help
xtester --list

xtester --all


# gather files from all nodes. gather accepts the follwing flags:
#  -tag      append the nodename to every file 
#  -maxsize  maximum size (kB) of files to copy back
gather -maxsize 10000

finalize_job

echo -e "\n $outdir content:"
ls -lt $outdir/*
echo -e " $outdir file space occupation:"
du -h -s $outdir

###------ END  ------###
# vim:syntax=sh:filetype=sh
