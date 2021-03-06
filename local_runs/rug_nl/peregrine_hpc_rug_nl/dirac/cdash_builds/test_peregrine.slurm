#!/bin/bash
#SBATCH --job-name=DIRACtest
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
##SBATCH --mem=50gb
#SBATCH --time=1-00:10:00

## memory per CPU ... is it working
#SBATCH --mem-per-cpu=3G

## stdout/stderr output file
#SBATCH -o log_slurm_job.%j.%N.std_out_err

## mail
#SBATCH --mail-user=Miroslav.Ilias@umb.sk

 
echo Job user is $SLURM_JOB_USER and his job $SLURM_JOB_NAME has assigned ID $SLURM_JOBID
echo This job was submitted from the computer $SLURM_SUBMIT_HOST
echo and from the home directory:
echo $SLURM_SUBMIT_DIR
echo
echo It is running on the cluster compute node:
echo $SLURM_CLUSTER_NAME
echo and is employing $SLURM_JOB_NUM_NODES node/nodes:
echo $SLURM_JOB_NODELIST
echo The job requests $SLURM_CPUS_ON_NODE CPU per task.

## Modules
  module load git/2.8.0-foss-2016a
  #module load intel/2016a
  module load iccifort/2015.2.164
  module load imkl/11.3.1.150-iimpi-8.1.5-GCC-4.9.3-2.25
  module load ifort/2015.2.164
  module load icc/2015.2.164
  #module load OpenMPI/1.8.6-iccifort-2015.2.164-i8
  module load CMake/3.6.1-foss-2016a
echo "loaded modules:"
module list

# my own OpenMPI installation
export PATH=/home/f113112/work/qch/software/openmpi-2.1.1_intel-15/bin:$PATH
export LD_LIBRARY_PATH=/home/f113112/work/qch/software/openmpi-2.1.1_intel-15/lib:$LD_LIBRARY_PATH

echo -e "\nRunning on host `hostname`"
echo -e "Time is `date` \n"
echo -e "\nMy PATH=$PATH\n"

# CPU model, total numer of CPUs, number of allocated CPUs
echo -e "The node's CPU \c"; cat /proc/cpuinfo | grep 'model name' | uniq
NPROCS=`cat /proc/cpuinfo | grep processor | wc -l`
echo -e "This node has $NPROCS CPUs available."
#
echo "(i) This node has SLURM_CPUS_ON_NODE=$SLURM_CPUS_ON_NODE CPUs allocated for SLURM calculations."
echo "(ii) This node has SLURM_JOB_CPUS_PER_NODE=$SLURM_JOB_CPUS_PER_NODE CPUs allocated for SLURM calculations."

echo -e "\n The memory at the node (in GB); free -t -g"
free -t -g
echo

## set internal OpenMP parallelization for MKL - Slurm CPU count
#export MKL_NUM_THREADS=$SLURM_CPUS_ON_NODE

# no OpenMP multithreading, use full OpenMPI for dirac.x
export MKL_NUM_THREADS=1
echo -e  "\nInternal MKL parallelization upon SLURM CPU count, MKL_NUM_THREADS=$MKL_NUM_THREADS\n"
export OMP_NUM_THREADS=1
export MKL_DYNAMIC="FALSE"
export OMP_DYNAMIC="FALSE"

#export DIRAC=/home/f113112/work/qch/software/dirac/production_trunk
export DIRAC=/home/f113112/work/qch/software/dirac/trunk
#export BUILD=$DIRAC/build_cmake_openmpi_intelmkl_i8_xh/
export BUILD=$DIRAC/build_cmake_openmpi_intel_openblas_i8_xh

# set MPI launcher
export DIRAC_MPI_COMMAND="mpirun -np $SLURM_CPUS_ON_NODE"
#export DIRAC_MPI_COMMAND="mpirun -np 2"
export PAM=$BUILD/pam
export BASDIR=$DIRAC/basis_dalton:$DIRAC/basis:$DIRAC/basis_ecp


echo -e "Python -v :\c"; python -V
echo -e "git ? \c"; git --version
echo -e "cmake ? which cmake = \c"; which cmake
echo -e "ctest ? which ctest = \c"; which ctest
echo -e "ctest --version = \c"; ctest --version
echo -e "mpirun ? which mpirun  = \c"; which mpirun
echo -e "mpirun --version = \c"; mpirun --version
echo -e "mpif90 ? which mpif90 = \c"; which mpif90
echo -e "mpif90 --version \c"; mpif90 --version
#echo -e "\nThe 'expr $SLURM_CPUS_ON_NODE / 2' gives \c"; expr $SLURM_CPUS_ON_NODE / 2
#echo -e "Also result from that expression directly ...`expr $SLURM_CPUS_ON_NODE / 2`" 

#export DIRAC_TMPDIR=/data
export DIRAC_TMPDIR=/scratch
echo -e "\nDIRAC scratch directory space, $DIRAC_TMPDIR"
df -h $DIRAC_TMPDIR/.
echo
echo -e "For mere comparison, df -h /tmp/."; df -h /tmp

echo -e "\n Resulting executable, ldd $BUILD/dirac.x:"
ldd $BUILD/dirac.x
echo -e "\n Important variable DIRAC_MPI_COMMAND=$DIRAC_MPI_COMMAND"

# for running jobs from your homedir, use ...
cd $SLURM_SUBMIT_DIR

echo -e "\n Current directory where this SLURM job is running `pwd`"
echo " It has the disk space of (df -h) :"
df -h .
echo

$PAM --noarch --mw=110 --nw=100 --aw=120 --inp=$DIRAC/test/cc_linear/cc.inp  --mol=$DIRAC/test/cc_linear/N2.ccpVDZ.mol



exit
