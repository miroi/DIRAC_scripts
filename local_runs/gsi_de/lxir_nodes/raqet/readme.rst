RAQET in lxir127
================

milias@lxir127.gsi.de:/tmp/milias-work/software/qch/raqet/raqet-package/../install.sh 

Starting RAQET install wizard...

  - This wizard needs following information.
     - Path to the directory where you want to install RAQET.

  - '->' requires your input from console.
  - Default value will be shown in '[]'.
  - You can stop wizard with entering 'q' in every input situation.

  Do you want to continue?(y/n) [y] ->y

STEP1
  Specify your RAQET installation path:
  (if '/opt' is entered, '/opt/raqet.1.0/' will be created.)

    Input full path ->/tmp/milias-work/software/qch/raqet/
      Exist and writable path

CONFIRMATION
  Your RAQET installation detail is as follows:

    - Installation path  : /tmp/milias-work/software/qch/raqet/raqet.1.0/

  It will take about 102 MB space to install RAQET.

  Do you want to start install?(y/n) [y] ->y

INSTALL
  Deploy RAQET manuals... done
  Deploy RAQET samples... done
  Deploy RAQET basis files... done
  Deploy RAQET license and readme files... done
  Deploy RAQET Serial Package ... done
  Create raqet-config.bash
  Create raqet-config.csh

RAQET has been installed successfully !!

================================================================

1. To run RAQET, make sure that environment variables are
   set appropriately by loading configure script file
   (e.g. of bash: source /tmp/milias-work/software/qch/raqet/raqet.1.0/raqet-config.bash
            csh:  source /tmp/milias-work/software/qch/raqet/raqet.1.0/raqet-config.csh).

2. To run sample calculations (/tmp/milias-work/software/qch/raqet/raqet.1.0/samples),
   copy /tmp/milias-work/software/qch/raqet/raqet.1.0/samples/ to your own directory
   and run job scripts in samples.

3. For further details, see manuals in
   /tmp/milias-work/software/qch/raqet/raqet.1.0/manuals/

Exit RAQET install wizard ...

Running test set
----------------
 milias@lxir127.gsi.de:/tmp/milias-work/software/qch/raqet/raqet-package/.

 milias@lxir127.gsi.de:/tmp/milias-work/My_scripts/local_runs/gsi_de/lxir_nodes/raqet/samples/.source /tmp/milias-work/software/qch/raqet/raqet.1.0/raqet-config.bash 

 milias@lxir127.gsi.de:/tmp/milias-work/My_scripts/local_runs/gsi_de/lxir_nodes/raqet/samples/../test.bash 

