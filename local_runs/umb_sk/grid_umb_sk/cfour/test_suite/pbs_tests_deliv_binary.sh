#!/bin/sh
##

#PBS -S /bin/bash
#PBS -A UMB-ITMS-26110230082
#PBS -N C4_tests
### Declare myprogram non-rerunable
#PBS -r n
#PBS -l nodes=1:ppn=12:old
##PBS -l nodes=1:ppn=8
#PBS -l walltime=20:00:00
#PBS -l mem=47g
##PBS -l mem=16g
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


#CFOUR=/home/milias/Work/qch/software/cfour/cfour_v2.00beta
CFOUR=/home/milias/Work/qch/software/cfour/cfour_v2.00beta_64bit_linux_serial

workdir=/mnt/local/$USER/$PBS_JOBID/CFOURrun
mkdir -p $workdir

cd $workdir
echo -e "pwd=\c"; pwd

cp -R $CFOUR/testsuite .
cp -R $CFOUR/bin  .
cp -R $CFOUR/share  .
cp -R $CFOUR/basis  .
ls -lt

#PATH=".:$PATH:$PWD/intelmklpar/bin"
PATH=".:$PATH:$PWD/bin"  # add executable to PATH
echo -e "\n PATH=$PATH"

#
# Run tests
#
cd testsuite
#xtester --whatistested
#xtester --help
#xtester --list
xtester --all
#xtester --testcase 354 # for Devin

exit 0
