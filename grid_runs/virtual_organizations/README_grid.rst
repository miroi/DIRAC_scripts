=====================================
Running DIRAC in the grid environment
=====================================

Building up, launching and testing of the DIRAC program suite in the grid enviroment.

The aim of this folder is to provide user with some teplates for the 
grid-computing.

DIRAC is packed and the tar-ball is copied onto chosen VO location - storage
element (SE), 
from where an assigned computing element (CE) unpacks it and performs own calculations.

Python script is not yet used for launching jdl-initiated script due to possibility
that not all CE are equipped with appropriate python version. So we resort to the bash shell.

Making dirac.x static
---------------------

Don't forget to include "--static" to your setup flags.

Making Python static
--------------------

 http://stackoverflow.com/questions/1150373/compile-the-python-interpreter-statically
 http://bugs.python.org/msg161300

Download Python-2.7.3

::

  $./configure --prefix=/home/ilias/bin/python_static  LDFLAGS="-static -static-libgcc" CPPFLAGS="-static"

put "\*static\*" into Modules/Setup.dist and type ::

  $ make -i install
  $ make install

-------------
Available VOs
-------------

So far I got membership in these virtual organizations:

::

 enmr.eu
 chem.vo.ibergrid.eu
 compchem(?)
 gaussian
 sivvp.slovakgrid.sk
 vo.africa-grid.org
 voce


-----------------------------
Working with your certificate
-----------------------------

Simple initialization :

::

 voms-proxy-init --voms voce
 voms-proxy-init --voms sivvp.slovakgrid.sk


More advanced initialization:

::

  voms-proxy-init --voms voce -hours 24 -vomslife 24:00 --out ~/voce_cert; export X509_USER_PROXY=~/voce_cert; voms-proxy-info --all

  voms-proxy-init --voms enmr.eu -hours 24 -vomslife 24:00 --out ~/enmr_eu_cert; export X509_USER_PROXY=~/enmr_eu_cert; voms-proxy-info --all

  voms-proxy-init --voms chem.vo.ibergrid.eu -hours 24 -vomslife 24:00 --out ~/ibergrid_eu_cert; export X509_USER_PROXY=~/ibergrid_eu_cert; voms-proxy-info --all

  voms-proxy-init --voms sivvp.slovakgrid.sk -hours 24 -vomslife 24:00 --out ~/sivvp_cert; export X509_USER_PROXY=~/sivvp_cert; voms-proxy-info --all

  voms-proxy-init --voms compchem -hours 24 -vomslife 24:00  --out ~/compchem_cert; export X509_USER_PROXY=~/compchem_cert

  voms-proxy-init --voms osg  -hours 24 -vomslife 24:00 --out ~/osg_cert; export X509_USER_PROXY=~/osg_cert; voms-proxy-info --all

  voms-proxy-init --voms gaussian  -hours 24 -vomslife 24:00 --out ~/gaussian_cert; export X509_USER_PROXY=~/gaussian_cert; voms-proxy-info --all

  voms-proxy-init --voms vo.africa-grid.org  -hours 24 -vomslife 24:00 --out ~/africa-grid_cert; export X509_USER_PROXY=~/africa-grid_cert; voms-proxy-info --all


where you can point your environmental variable to given certificate:

::

 export X509_USER_PROXY=~/voce_cert
 export X509_USER_PROXY=~/sivvp_cert
 export X509_USER_PROXY=~/compchem_cert
 export X509_USER_PROXY=~/enmr_eu_cert


Long-term certificate
---------------------

Create and store a long-term proxy (default 7 days):

::

  myproxy-init  --pshost myproxy.cnaf.infn.it -d -n  # compchem
  myproxy-init  --pshost px.ui.savba.sk  -d -n       # voce, sivvp


Create certificate for longer time:

::

  myproxy-init  --pshost px.ui.savba.sk        -d -n -c 4780       # voce, cca 198.1 days (maximum) 
  myproxy-init  --pshost myproxy.cnaf.infn.it  -d -n -c 4780       # compchem, cca 198.1 days (maximum) 

where "--pshost <myproxy_server>" specifies the hostname of the machine where a MyProxy Server runs, 
the -d option instructs the server to associate the user DN to the proxy, 
and the -n option avoids the use of a passphrase to access the long-term proxy, 
so that the WMS renews the proxy automatically. 

Verify your long-term certificate:

::

  myproxy-info -v -d --pshost px.ui.savba.sk
  myproxy-info -v -d --pshost myproxy.cnaf.infn.it

List of all valid proxies:

::

 voms-proxy-info --all

Destroy current proxies: 

::

  voms-proxy-destroy
  myproxy-destroy 


------------------
VO Data management
------------------

Accesible nodes/storage space:

::

  lcg-infosites -vo voce all
  lcg-infosites -vo compchem se
  lcg-infosites -vo sivvp.slovakgrid.sk all
  lcg-infosites -vo enmr.eu se
  lcg-infosites -vo gaussian all
  lcg-infosites -vo vo.africa-grid.org all
  lcg-infosites -vo chem.vo.ibergrid.eu all

Accesible computing elements:

::

  lcg-infosites -vo voce ce
  lcg-infosites -vo compchem ce
  lcg-infosites -vo sivvp.slovakgrid.sk ce
  lcg-infosites -vo enmr.eu ce

Create directory in  VO's lfn-space 

::

  lfc-mkdir /grid/enmr.eu/ilias


What you have in your VO's lfn-space (must have active certificate for this VO):

::

  lcg-ls -l  lfn://grid/voce/ilias/
  lcg-ls -l  lfn://grid/compchem/ilias
  lcg-ls -l  lfn://grid/sivvp.slovakgrid.sk/ilias
  lcg-ls -l  lfn://grid/enmr.eu/ilias

For the command above, you must activate the LFC_HOST variable:

::

  export LFC_HOST=`lcg-infosites --vo sivvp.slovakgrid.sk lfc` 
  export LFC_HOST=`lcg-infosites --vo voce lfc`
  export LFC_HOST=`lcg-infosites --vo enmr.eu lfc`


Also, to deal with data, you must specify the VO_SE variable for each VO, pointing to your favorite SE:

::

  VO_SE="se.ui.savba.sk" # for sivvp.slovakgrid.sk, voce
  VO_SE="gb-se-amc.amc.nl" for enmr.eu


Donwload files from distant SE into your current directory 
(must have active certificate, LFC_HOST and VO_SE variables for give VO):

::

 lcg-cp  lfn://grid/sivvp.slovakgrid.sk/ilias/DIRAC4Grid_suite.tgz   file://$PWD/DIRAC4Grid_suite.tgz
 lcg-cp  lfn://grid/voce/ilias/DIRAC_grid_suite.tgz                  file://$PWD/DIRAC_grid_suite.tgz
 lcg-cp  lfn://grid/compchem/ilias/dirac_current.tgz                 file://$PWD/dirac_current.tgz



Delete selected data from your personal SE space:

::

  lcg-del -a lfn://grid/voce/ilias/Dirac_grid_suite.tgz

  lcg-del -a lfn://grid/compchem/ilias/Dirac_grid_suite.tgz

  lcg-del -a lfn://grid/sivvp.slovakgrid.sk/ilias/Dirac_grid_suite.tgz

  lcg-del -a lfn://grid/enmr.eu/ilias/DIRAC4Grid_suite.tgz

 
Put (upload) a file to your VO's data storage space. You must first set the VO_SE variable

:: 

  lcg-cr -d $VO_SE file:$PWD/DIRAC4Grid_suite.tgz  -l lfn://grid/voce/ilias/DIRAC4Grid_suite.tgz

  lcg-cr -d $VO_SE file:$PWD/DIRAC_grid_suite.tgz  -l lfn://grid/compchem/ilias/DIRAC_grid_suite.tgz

  lcg-cr -d $VO_SE file:$PWD/DIRAC4Grid_suite.tgz  -l lfn://grid/sivvp.slovakgrid.sk/ilias/DIRAC4Grid_suite.tgz

  lcg-cr -d $VO_SE file:$PWD/DIRAC4Grid_suite.tgz  -l lfn://grid/enmr.eu/ilias/DIRAC4Grid_suite.tgz


And you get answer like:

::

  guid:1a4c183f-9335-47f4-af01-b358cc454f78


and for compchem you have to use the command:

::

  lcg-cr -d se.grid.unipg.it  -l  lfn://grid/compchem/ilias/dirac_grid_suite.tgz --vo compchem  dirac_grid_suite.tgz


Check ACL (access control list) attributes (you must have the LFC_HOST variable for given VO ) :

::

 lfc-getacl /grid/sivvp.slovakgrid.sk/ilias
 lfc-getacl /grid/voce/ilias
 lfc-getacl /grid/compchem/ilias
 lfc-getacl /grid/enmr.eu/ilias


Set ACL - only the user has all rights (remove them from group and others)
(see also https://grid.sara.nl/wiki/index.php/Access_Control_Lists):

::

 lfc-setacl -m user::rwx,group::,other:: /grid/sivvp.slovakgrid.sk/ilias
 lfc-setacl -m user::rwx,group::,other:: /grid/voce/ilias
 lfc-setacl -m user::rwx,group::,other:: /grid/compchem/ilias
 lfc-setacl -m user::rwx,group::,other:: /grid/enmr.eu/ilias

Donwload files from SE into your server's current directory:

:: 

 lcg-cp  lfn://grid/sivvp.slovakgrid.sk/ilias/DIRAC4Grid_suite.tgz             file://$PWD/DIRAC4Grid_suite.tgz
 lcg-cp  lfn://grid/voce/ilias/DIRAC4Grid_suite.tgz                            file://$PWD/DIRAC4Grid_suite.tgz


-----------------------------------
Working with the "gLite" middleware
-----------------------------------

Some "gLite" howtos :
 http://egee-uig.web.cern.ch/egee-uig/production_pages/SimpleJobCycle.html
 http://iag.iucc.ac.il/workshop/complex_jobs.htm

Retrieve the list computing elements that match your job:

::

  glite-wms-job-list-match -a submit_voce.jdl
  glite-wms-job-list-match -a submit_compchem.jdl
  glite-wms-job-list-match -a submit_sivvp.jdl
  glite-wms-job-list-match -a submit_enmr_eu.jdl


Submit your job script: 

::

 glite-wms-job-submit -o <JOB_ID_file> -a submit.jdl


Submit job for the given VOs, with saving info file:

::

 glite-wms-job-submit -o  JOB_sivvp  -a submit_sivvp.jdl 
 glite-wms-job-submit -o  JOB_voce   -a submit_voce.jdl 
 glite-wms-job-submit -o JOB_enmr_eu -a  submit_enmr_eu.jdl


Get job status (Python 2.7, not 3.3 )

:: 

 glite-wms-job-status  -i <JOB_ID_file>


Calncel your job (i.e. runs too long, maybe hanged)

::

 glite-wms-job-cancel -i JOB_enmr_eu
 glite-wms-job-cancel -i JOB_sivvp



Intermediate results of your job
--------------------------------

First, add two lines to your jdl-file: 

::

 PerusalFileEnable=true;
 PerusalTimeInterval=30;


Next, specify the files (here DIRAC_tests_std.out and DIRAC_tests_std.err) you want to view: 

::  

 glite-wms-job-perusal --set -f DIRAC_runs.stdout -f DIRAC_runs.stderr -i JOB_id


Execute the following command to retrieve the current output: 

::

 glite-wms-job-perusal --get -f DIRAC_runs.stdout -i JOB_id


Obtaining grid run files
------------------------

 
Get grid job files back (to default /tmp directory)

::

 glite-wms-job-output -i <JOB_ID_file>


Get job files back to user's current directory

::

 glite-wms-job-output --dir $PWD  -i JOB_sivvp
 glite-wms-job-output --dir $PWD  -i JOB_enmr_eu



Attributes of computing elements
--------------------------------

Querry computing elements on list of avaiable attributes:

::

 lcg-info --list-attrs --vo sivvp.slovakgrid.sk
 lcg-info --list-attrs --vo enmr.eu



Querry computing elements on selected attributes:

::

 lcg-info  --list-ce  --query 'LRMS=pbs' --vo voce
 lcg-info  --list-ce  --query 'LRMS=pbs' --vo compchem
 lcg-info  --list-ce  --query 'LRMS=pbs' --vo osg

 lcg-info  --list-ce --query 'TotalCPUs>=8' --vo voce
 lcg-info  --list-ce --query 'TotalCPUs>=24,FreeCPUs>=5' --vo compchem
 lcg-info  --list-ce --query 'TotalCPUs>=24,FreeCPUs>=5,FreeJobSlots>=2' --vo voce

 lcg-info --list-ce  --query 'CE=*' --attrs EstRespTime,TotalCPUs,Memory,ClockSpeed,Cluster --vo voce
 lcg-info --list-ce  --query 'CE=*' --attrs EstRespTime,MaxCPUTime,TotalCPUs,Memory,ClockSpeed,MaxTotalJobs,Cluster  --vo voce
 lcg-info --list-ce  --query 'CE=*' --attrs EstRespTime,MaxCPUTime,TotalCPUs,Memory,ClockSpeed,Cluster,VMemory   --vo compchem

 lcg-info --list-ce --attrs MaxWCTime --vo voce
 lcg-info --list-ce --attrs RunningJobs,FreeCPUs,MaxWCTime,MaxCPUTime --vo voce
 lcg-info --list-ce --attrs Memory,VMemory  --vo voce
 lcg-info --list-ce --attrs PlatformArch --vo voce
 lcg-info --list-ce --query 'PlatformArch=x86_64' --vo voce


Querry tag attributes :

::

 lcg-info --list-ce --query 'Tag=*MPICH*' --attrs 'CE' --vo voce
 lcg-info --list-ce --query 'Tag=*GCC*'   --attrs 'CE' --vo voce


Miscel
------

Launch your bash-script with the help of the nohup command: 

::

 nohup grid3savba_cdash_grid_buildup.bash voce     > nohup_voce 2>&1 & 
 nohup grid3savba_cdash_grid_buildup.bash compchem > nohup_compchem 2>&1 & 

