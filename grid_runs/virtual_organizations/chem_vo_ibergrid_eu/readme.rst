PROBLEM:

ilias@grid.ui.savba.sk:/scratch/milias/Work/qch/software/My_scripts/grid_runs/virtual_organizations/chem_vo_ibergrid_eu/1_node/. voms-proxy-init --voms chem.vo.ibergrid.eu -hours 24 -vomslife 24:00 --out ~/ibergrid_eu_cert; export X509_USER_PROXY=~/ibergrid_eu_cert; voms-proxy-info --all
Enter GRID pass phrase for this identity:
Contacting ibergrid-voms.ifca.es:40009 [/DC=es/DC=irisgrid/O=ifca/CN=host/ibergrid-voms.ifca.es chem.vo.ibergrid.euchem.vo.ibergrid.eu voms01.ncg.ingrid.pt 40009 /C=PT/O=LIPCA/O=LIP/OU=Lisboa/CN=voms01.ncg.ingrid.pt] "chem.vo.ibergrid.eu"...
Remote VOMS server contacted succesfully.

VOMS server ibergrid-voms.ifca.es:40009 returned the following errors:
chem.vo.ibergrid.eu: User unknown to this VO.
None of the contacted servers for chem.vo.ibergrid.eu were capable of returning a valid AC for the user.
User's request for VOMS attributes could not be fulfilled.
Proxy not found: /home/ilias/ibergrid_eu_cert (No such file or directory)
ilias@grid.ui.savba.sk:/scratch/milias/Work/qch/software/My_scripts/grid_runs/virtual_organizations/chem_vo_ibergrid_eu/1_node/.

