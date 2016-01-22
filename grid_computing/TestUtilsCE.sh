#!/bin/sh
#######################################################################################################
#
#
#         Test script for copying and launching the DIRAC suite on grid CE
#
#
#######################################################################################################

# check the parameter - VO name
if [[ $1 != "voce" && $1 != "compchem" && $1 != "isragrid" && $1 != "osg" ]]; then
 echo -e "\n wrong parameter - VO name : $1 "
 exit 12
else
 VO=$1
 echo -e "OK, you specified properly the VO=$VO, continuing \n"
fi

# include all external functions
if [ -e "UtilsCE.sh" ]
then
  source ./UtilsCE.sh
 # declare -F
else
  echo "Source file UtilsCE not found!"
  exit 11
fi

print_CE_info
querry_CE_attributes $VO

#check_file_on_SE $VO
# download & unpack tar-file onto CE - MUST be successfull or exit

#downloadCE $VO
#RETVAL=$?; [ $RETVAL -ne 0 ] && exit 4

# get number of procs #
get_nprocs_CE ntprocs
RETVAL=$?; [ $RETVAL -ne 0 ] && exit 5
echo -e "\n Number of #CPU obtained from the function: $ntprocs"
final_message

exit 0
