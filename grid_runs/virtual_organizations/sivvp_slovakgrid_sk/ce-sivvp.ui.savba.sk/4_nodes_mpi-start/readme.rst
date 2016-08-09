Dirac parallel on 4-nodes on VO=sivvp
=====================================

- export DIRAC_MPI_COMMAND="mpirun  -np 8 -npernode 2 --prefix $BUILD_MPI1" # this is crashing !

- try export DIRAC_MPI_COMMAND="mpirun -H ${UNIQUE_NODES} -npernode 2 -x PATH -x LD_LIBRARY_PATH --prefix $BUILD_MPI1"

- fix job onto other.GlueCEUniqueID == "ce-sivvp.ui.savba.sk:8443/cream-pbs-sivvp" ... there PBS is running ..

- use mpi-run for your job !

