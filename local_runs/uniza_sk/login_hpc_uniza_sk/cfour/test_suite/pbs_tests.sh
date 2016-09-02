#!/bin/sh

### Set the job name
#PBS -N cfour
#PBS -r n 
#PBS -q parallel
#PBS -j oe
#PBS -l nodes=1:ppn=12
#PBS -l mem=47g
#PBS -l walltime=200:00:00

### Run some informational commands.
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo This jobs runs on the following processors:
echo `cat $PBS_NODEFILE`
echo "Unique nodes (processors), from PBS_NODEFILE:"
echo `cat $PBS_NODEFILE | sort | uniq `
 
### Define number of processors for the job
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS cpus
echo -e "# of processors in node: \c"; cat /proc/cpuinfo | grep processor | wc -l
echo -e "The host (main) node has $NCPUS cpus."
UNIQUE_NODES="`cat $PBS_NODEFILE | sort | uniq`"
UNIQUE_NODES="`echo $UNIQUE_NODES | sed s/\ /,/g `"
echo "Unique nodes (processors) :  $UNIQUE_NODES"

export MKL_NUM_THREADS=${NPROCS}
export MKL_DYNAMIC="FALSE"
export OMP_NUM_THREADS=1
#
echo -e "\nMKL_NUM_THREADS=$MKL_NUM_THREADS"
echo -e "MKL_DYNAMIC=$MKL_DYNAMIC"
echo -e "OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo -e "--------------------------------------------\n"

# distributed binaries
CFOUR=/work/umbilias/work/software/cfour/cfour_v2.00beta_64bit_linux_serial
workdir=/localscratch/$PBS_JOBID/$USER/CFOURrun_bin
mkdir -p $workdir

cd $workdir
echo -e "pwd=\c"; pwd

cp -R $CFOUR/testsuite $workdir/.
cp -R $CFOUR/bin       $workdir/.
cp -R $CFOUR/share     $workdir/.
cp -R $CFOUR/basis     $workdir/.

#
echo -e "\n \n Distributed CFOUR with binaries"
cd $workdir
export PATH=$CFOUR/bin:$PATH
echo -e "\n PATH=$PATH"
cd testsuite
xtester --all

/bin/rm -rf $workdir

exit 0
