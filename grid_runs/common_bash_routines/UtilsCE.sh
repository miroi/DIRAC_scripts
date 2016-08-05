############################################################################
#
# List of specific functions in shell language related to execution of DIRAC 
# software in grid environment.
#
# Add it to your script at the beginning as "source UtilsCE.sh"
# as function declarations must precede their calls.
#
# Written by Miroslav Ilias, Oct.2012
#
############################################################################

echo -e "\n Going to source - include - file with bash shell functions, $0 ."

function get_nprocs_CE()
{ # function , http://www.linuxjournal.com/content/return-values-bash-functions
  local result=$1 # store variable name
  #unset npr
  local npr=`cat /proc/cpuinfo | grep processor | wc -l`
  RETVAL=$?; [ $RETVAL -ne 0 ] && exit 42
  eval $result="'$npr'"
}

function print_CE_info ()
{ # prints basic info about given CE
unset HOSTNAME
HOSTNAME=`hostname -f`
if [[ -z $HOSTNAME ]]; then
 HOSTNAME=`hostname`
fi
echo -e "\n --- Hostname: $HOSTNAME "; 
echo -e "\n --- Hostname: $GLITE_WMS_LOG_DESTINATION "; 
# ----
THIS_HOSTNAME=$GLITE_WMS_LOG_DESTINATION 
# ----
echo -e "Server specification: \c";  uname -a
echo -e "\n shell version, sh --version:"; sh --version
######################################################
#     get number of CPUs on the given node
######################################################
local np
get_nprocs_CE np
echo -e "\n==== CPU \c"; cat /proc/cpuinfo | grep "model name"  | tail -n 1
echo -e  "==== Number of all CPUs     :  $np   ";
if [[ -n $PBS_NODEFILE ]]; then
  local np_PBS=`cat $PBS_NODEFILE | wc -l`
  echo -e  "==== Number of allowed CPUs, from PBS_NODEFILE :  $np_PBS  ";
  echo -e "-- PBS_NODEFILE=$PBS_NODEFILE"
  echo -e "-- PBS_NUM_PPN =$PBS_NUM_PPN"
else
  echo -e "\n No PBS variables found on this server...\n"
fi
#####################
###  memory of CE ###
#####################
echo -e "\n ---- server's total memory :\c"; cat /proc/meminfo | grep MemTotal
echo -e "through the 'free -t -m' command (values in MB): "; free -m -t
#####################
# check space on CE #
#####################
echo -e "\n--- My current directory :  $PWD "
echo -e "--- Server's current dir filesystem (df -h .): "; df -h .
echo -e "--- Occupied current space by me (du -hs .) : \c"; du -hs .

echo -e "\n--- Server's tmp filesystem (df -h /tmp/.): "; df -h /tmp/.
echo -e "\n--- Server's whole filesystem (df -h): "; df -h

echo -e "\n\n ****  server environment:  set command  ****"; set 
echo -e "\n\n Is there cmake ? which cmake="; which cmake
echo -e "Is python present ? \c"; which python; python -V
echo -e "\n Is lcg-cp ? \c"; which lcg-cp
echo -e "\n Is lcg-cr ? \c"; which lcg-cr
return 0
} 

function querry_CE_attributes()
{ #   ask on values of CE parameters   # 
local VO=$1
echo -e "\n First, on CE=$CE, VO=$VO checking long-term proxy with myproxy-info -v : "
if [[ "$VO" == "voce" ]]; then
  myproxy-info -v -d --pshost px.ui.savba.sk
elif [[ "$VO" == "compchem" ]]; then
  myproxy-info -v -d --pshost myproxy.cnaf.infn.it
else
  echo -e "\n What is your VO ? Neither voce,nor compchem..."
fi
#
echo -e "\n Checking short-term proxy, stamped with myproxy, voms-proxy-info --all : "
voms-proxy-info --all
#
if [[ -n $CE_ID ]]; then
# get info about CE #
  local attribs="UsedOnline,TotalOnline,FreeOnline,TotalNearline,SMPSize,TotalCPUs,PlatformArch,Memory,VMemory,ClockSpeed,MaxCPUTime,MaxWCTime,CPUVendor,PhysicalCPU,CE,CEStatus,FreeCPUs,Cluster"
  echo -e "\n Going to querry attribute on this CE=$CE_ID:"
  echo -e "attributes of interest are: $attribs"
  #lcg-info --list-ce --query "CE=$CE_ID" --attrs PlatformArch,SMPSize,TotalCPUs,Memory,VMemory,ClockSpeed,MaxCPUTime
  lcg-info --list-ce --query "CE=$CE_ID" --attrs $attribs
  CE_BDII=${CE_ID/:*/:2170}
  echo -e "\n Now faster querrying of attributes using CE_BDII=$CE_BDII"
  #lcg-info --list-ce --bdii "$CE_BDII" --query "CE=$CE_ID" --attrs UsedOnline,TotalOnline,FreeOnline,TotalNearline,SMPSize,TotalCPUs,PlatformArch,Memory,VMemory,ClockSpeed,MaxCPUTime,CPUVendor,PhysicalCPU,CE,CEStatus,FreeCPUs,Cluster
  lcg-info --list-ce --bdii "$CE_BDII" --query "CE=$CE_ID" --attrs $attribs
else
  echo -e "\n No querrying of attributes as the CE_ID variable is not defined !"
  echo -e " This means that we are not on a CE ! \n"
fi
return 0
}

function download_from_SE()
{ # download file from SE to the current CE local directory, parameter - name of VO
local VO=$1
#local DownlFile="dirac_grid_suite.tgz"
local DownlFile=$2
#
local getcmd="lcg-cp -v lfn://grid/$VO/ilias/$DownlFile file://$PWD/$DownlFile"
echo -e "\n Going to download file $DownlFile from SE, 1st attempt, $getcmd "
$getcmd
RETVAL=$?
echo -e "FYI: downloading ended with code $RETVAL"
# this command works ... don't forget ";" and spaces between "{","}" and commands
#$getcmd || { echo "once again"; { $getcm || { echo -e "Download failed second time ! Exit !!! "; exit 41; } } }
#
echo -e "\nDownloaded file attributes (ls -lt $DownlFile) :"
ls -lt $DownlFile || { echo -e "\n\nNo dowloaded file found in CE's current directory, exit 32 !"; exit 32; }
echo -e " -------------------------------------------------------------------------------------\n"
return 0
}

#
# uploads resulting tar-file from to the current CE's local directory to the assigned SE
#
# entering parameter - name of VO
#
function upload_to_SE()
{ 
  echo -e "\n Going to upload resulting tarball onto SE."
  local VO=$1
  if [[ $VO == "compchem" ]]; then
     #VO_SE="aliserv6.ct.infn.it" - does not work, try other SE...
     VO_SE="grid2.fe.infn.it"
     echo -e "set storage element of VO=$VO, VO_SE=$VO_SE"
  elif [[ $VO == "voce" ]]; then
     VO_SE="se.ui.savba.sk"
     echo -e "set storage element of VO=$VO, VO_SE=$VO_SE"
  else
     echo -e "no storage element found for VO=$VO"
     exit 39
  fi
  # timestamp
  local timestamp1=`date +\%F_\%k-\%M-\%S`; timestamp=${timestamp1// /};
  echo "...created file timestamp=$timestamp"
  # find version
  echo -e "\n Get lcg-cr --version:"; lcg-cr --version
  # own command, must have proper form ! 
  local putcmd="lcg-cr -v --vo $VO -d $VO_SE -l lfn://grid/$VO/ilias/dirac_grid_suite_back_$VO_${timestamp}.tgz  file:$PWD/dirac_grid_suite_back.tgz"
  echo -e "\n Going to upload resulting tab-ball onto SE, command: $putcmd "
  $putcmd
  local RETVAL=$?
  echo -e "FYI: this uploadig ended with code $RETVAL"
  if [ $RETVAL -eq 0 ]
  then
    echo "the output tarfile file was successfully copied to the SE=$VO_SE :"
    lcg-ls -l lfn://grid/$VO/ilias/
  else
    echo "unable to copy output file to the SE !" 
  fi
  echo -e " -------------------------------------------------------------------------------------\n"
  return $RETVAL
}

function check_file_on_SE()
{ # parametric call with name of VO
local VO=$1
local DIRACpack=$2
echo -e "\n\n On the host CE, checking variable LFC_HOST=$LFC_HOST"
if [[ -z $LFC_HOST ]];  then
  echo -e "The LFC_HOST environmental variable is not defined !"
  echo -e "Trying command lcg-infosites --vo $VO lfc :"; lcg-infosites --vo $VO lfc
  export LFC_HOST=`lcg-infosites --vo $VO lfc`
fi
echo -e  "\n Files in my vo=$VO SE space, lcg-ls -l lfn://grid/$VO/ilias:"
lcg-ls -l lfn://grid/$VO/ilias || { echo -e "...previous command failed, once again... "; lcg-ls -l lfn://grid/$VO/ilias; }
echo -e "\n File attributes lcg-lr lfn://grid/$VO/ilias/$DIRACpack:"
lcg-lr lfn://grid/$VO/ilias/$DIRACpack || { echo -e "...previous command failed, once again... "; lcg-lr  lfn://grid/$VO/ilias/$DIRACpack; }
echo " ------------------------------------------------------------------------- "
# for these commands we need the LFC_HOST variable
echo -e "\n check users's LFC-directory, lfc-getacl /grid/$VO/ilias:"
lfc-getacl  /grid/$VO/ilias
echo -e "\n check user's LFC-file, lfc-getacl /grid/$VO/ilias/$DIRACpack:"
lfc-getacl  /grid/$VO/ilias/$DIRACpack
echo -e "-----------------------------------------------------------\n"
return 0
}

#
# Simply unpack and check the freshly downloaded DIRAC tarball
#
function unpack_DIRAC()
{
# 
# argument: name of the tarball file
#
local DIRACpack=$1
echo -e "\n\n ---- Unpacking dowloaded DIRAC suite, tar program  : \c "
which tar;  tar --version
echo -e "Performing tar xfz $DIRACpack ...\c"
tar xfz $DIRACpack || { echo "some problems with tarball unpacking, error exit !"; exit 113; }
echo -e "\n Unpacking done; see the content of $PWD :"; ls -lt 
echo -e "\n Content of build* directories: "; ls -lt build*
echo -e "\n After unpacking, removing the file $DIRACpack ..."
/bin/rm $DIRACpack
return 0
}

#
# Print final message ...
#
function final_message()
{ 
echo -e "\n\n --------------------------------------------------------------------------------"
echo -e "Job finished at: \c"; date
echo -e "Filesystem on my space: "; df -h $PWD
echo -e "\n All files:"; ls -lt
echo -e "\n Total occupied space: \c"; du -h -s $PWD
echo -e "\n ----------------------------------------------------------------------------------"
echo -e "\n Finally, checking short-term proxy, stamped with myproxy, voms-proxy-info --all : "
voms-proxy-info --all
echo -e "\n ----------------------------------------------------------------------------------"
return 0
}

# flush out at the beginning
echo -e "\n --- List of all declated bash shell functions in this sourced file $0 : --- "
declare -F

