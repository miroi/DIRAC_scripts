#!/bin/sh

#PBS -S /bin/bash
#PBS -N C4_H2O
### Declare myprogram non-rerunable
#PBS -r n
#PBS -l nodes=1:ppn=12
#PBS -l walltime=6:00:00
#PBS -l mem=47g
#PBS -j oe
#PBS -q short

echo "Working host is: "; hostname -f

# load necessary modules
module load intel/2015
module load mkl/2015
#module load openmpi-intel/1.8.3
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

# distributed binaries
CFOURbin=/home/milias/Work/qch/software/cfour/cfour_v2.00beta_64bit_linux_serial
# own compiled version
CFOURown=/shared/home/ilias/Work/software/cfour/cfour_v2.00beta/build/intel_mklpar_i8

workdir1=/mnt/local/$USER/$PBS_JOBID/CFOURrun_bin
workdir2=/mnt/local/$USER/$PBS_JOBID/CFOURrun_own
mkdir -p $workdir1
mkdir -p $workdir2

cd $workdir1
echo -e "pwd=\c"; pwd

cp -R $CFOURown/testsuite $workdir1/.
cp -R $CFOURown/bin       $workdir1/.
cp -R $CFOURown/share     $workdir1/.
cp -R $CFOURown/basis     $workdir1/.


cp -R $CFOURbin/testsuite $workdir2/.
cp -R $CFOURbin/bin       $workdir2/.
cp -R $CFOURbin/share     $workdir2/.
cp -R $CFOURbin/basis     $workdir2/.

#
#
#
echo -e "\n \n Distributed CFOUR"
cd $workdir1
PATH=".:$PATH:$PWD/bin"  # add executable to PATH
echo -e "\n PATH=$PATH"
cd testsuite
xtester --all

#
#
#
echo -e "\n \n Own compiled CFOUR"
cd $workdir2
PATH=".:$PATH:$PWD/bin"  # add executable to PATH
echo -e "\n PATH=$PATH"
cd testsuite
xtester --all


exit 0