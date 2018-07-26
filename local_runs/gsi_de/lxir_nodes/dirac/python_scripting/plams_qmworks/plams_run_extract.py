#!/usr/bin/env python

from scm.plams import * 
from itertools import chain

# take care of pam script :
import sys
# This is the path to the folder containing pam without including pam
pam_path="/u/milias/Work/qch/software/dirac/trunk/build_intelmkl_i8_xh"
sys.path.append(pam_path)  # this does not work...

def main():                                                                                             
    #basis  = 'dyall.cv4z'                                                                                                  
    basis  = 'STO-2G'                                                                                                  
    bonds  = create_dist() 
    # name of the jobs to run e.g. "BaF_2.225"                                                                                                
    names  = ["HF_{:4.3f}".format(r) for r in bonds]     

    # Using the distance between the H and F create a Plams Molecule 
    mols   =  [create_molecule(*rs) for rs in zip(names, bonds)]                                                           

    # Write geometry in xyz format                                                                                                                       
    for mol, name in zip(mols, names):                           
        ns = '{}.xyz'.format(name)                                                                        
        mol.write(ns)                                              

   # Create all the dirac jobs for different molecular geometries                                                                                                                    
    jobs     = [create_job(basis, name, mol) for name, mol in zip(names, mols)]    

    jr = JobRunner(parallel=False,maxjobs=0) 
    # Running all the jobs    
    results  = [job.run(jobrunner=jr, nodes=1, walltime="00:15:00") for job in jobs] 

    # Waiting for the jobs to be executed 
    for r in results:                                                                                                      
        #r.wait()       
        energy=r.grep_output(pattern='@ Total CCSD(T) energy :')
        print('energy=',energy)

def create_job(basis, name, mol):
    """
     Function to create a CC Dirac Job using a basis, a name for the job and a plams molecule.
     Notice that DIRAC is case sensitive, therefore the Settings declaration should 
     follow this convention.
    """ 
    job  = DiracJob(name=name, molecule=mol)
    # It does not write the molecule in the input, instead it uses an xyz file 
    job.settings.ignore_molecule
    # pam parameter
    job.settings.runscript.pam.noarch = True

    job.settings.input.dirac['WAVE FUNCTION']                                                                              
    job.settings.input.dirac["4INDEX"]                                                                                     

    job.settings.input.GENERAL.PCMOUT

    job.settings.input.HAMILTONIAN.X2C
    job.settings.input.INTEGRALS.READIN["UNCONT"]  

    job.settings.input['WAVE FUNCTION']["scf"]                                                                             
    job.settings.input['WAVE FUNCTION']["relccsd"]

    #job.settings.input["WAVE FUNCTION"]["SCF"]["_en"] = True                                                               
    job.settings.input["WAVE FUNCTION"]["SCF"]["CLOSED SHELL"] = 10
    job.settings.input["WAVE FUNCTION"]["SCF"]["MAXITR"] = 55
    job.settings.input["WAVE FUNCTION"]["SCF"]["EVCCNV"] = "1.0D-9 5.0D-7"                                                 

    # active space for MOLTRA
    job.settings.input.moltra.active  = 'energy -20.0 30.0 0.01'                                                            

    job.settings.input.molecule.basis.default = basis                                                                      
    #job.settings.input.molecule.basis.special = 'F BASIS STO-2G'                                                          

    #job.settings.input.relccsd.FOCKSPACE                                                                                   
    job.settings.input.relccsd.ENERGY
    #job.settings.input.relccsd.CCSORT.NORECM                                                                               
    #job.settings.input.relccsd.CCFSPC.DOEA                                                                                 
    #job.settings.input.relccsd.CCFSPC.NACTP = '6 6'                                                                        

    return job    

def create_molecule(name, r):
    """
    Note: Alternatively you can provide to Plams with .xyz files, like:
     >>> mol = Molecule("<path/to/xyz>")
    """                                                                                              
    mol = Molecule()                                                                                                       
    mol.add_atom(Atom(symbol='H', coords=(0, 0, 0)))                                                                      
    mol.add_atom(Atom(symbol='F', coords=(0, 0, r)))                                                                       

    return mol    

def create_dist():                                                                                                         
    """
    Function to create few inter-nuclear distances.
    """                                                                                               
    xs1 = [1.7 + i * 1.0e-1 for i in range(1)]
    #xs2 = [2.0 + i * 2.5e-2 for i in range(20)]                                                                            
    #xs3 = [2.5 + i * 7.5e-2 for i in range(20)]                                                                            

    # Return the concatenation of the points                                                                                                                           
    #return list(chain(*[xs1, xs2, xs3])) 
    return list(chain(*[xs1])) 


if __name__ == "__main__":
    # Init should be called before calling the main function
    init()
    # run this script
    main()
   # finally clean the environment
    finish()
