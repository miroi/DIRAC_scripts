#!/bin/sh
#######################################################################################################
#
#
#   Script for downloading, upacking and launching the DIRAC4Grid suite on some grid CE of given VO.
#
#
#######################################################################################################

# check the parameter - VO name
if [[ $1 != "voce" && $1 != "compchem" && $1 != "isragrid" && $1 != "osg" && $1 != "sivvp.slovakgrid.sk"  && $1 != "enmr.eu" ]]; then
 echo -e "\n wrong parameter - VO name : $1 "
 exit 12
else
 VO=$1
 echo -e "\n OK, you specified properly the VO=$VO, continuing \n"
fi


# include all external functions from  file copied onto current CE
if [ -e "UtilsCE.sh" ]
then
  source ./UtilsCE.sh
else
  echo -e "\n Source file UtilsCE not found! Error exit 13 ! \n"
  exit 13
fi

# name of Dirac package distributed over grid clusters
package="DIRAC4Grid_suite.tgz"

print_CE_info
querry_CE_attributes $VO
#check_file_on_SE $VO $package
# download & unpack tar-file onto CE - MUST be successfull or exit
#download_from_SE $VO $package

# get number of procs #
unset nprocs
get_nprocs_CE nprocs
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 5
echo -e "\n Number of #CPU obtained from the function: $nprocs \n"

#
# Unpack the downloaded DIRAC tar-ball
#
#unpack_DIRAC $package
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 6

#-----------------------------------------------
#  specify the scratch space for DIRAC runs    #
#-----------------------------------------------
#echo "--scratch=\$PWD/DIRAC_scratch" >  ~/.diracrc
#echo -e "\n\n The ~/.diracrc file was created, containing: "; cat ~/.diracrc

##########################################
#      set build dirs and paths          #
##########################################

# take care of unique nodes ...
UNIQUE_NODES="`cat $PBS_NODEFILE | sort | uniq`"
UNIQUE_NODES="`echo $UNIQUE_NODES | sed s/\ /,/g `"
echo -e "\n Unique nodes for parallel run (from PBS_NODEFILE):  $UNIQUE_NODES"

echo "PBS_NODEFILE=$PBS_NODEFILE"
echo "PBS_O_QUEUE=$PBS_O_QUEUE"
echo "PBS_O_WORKDIR=$PBS_O_WORKDIR"

##############################################################
echo -e "\n --------------------------------- \n "; 
#############################################
#### flush out some good-bye message ... ####
#############################################
final_message

exit 0
