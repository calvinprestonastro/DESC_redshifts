#!python
from cosmosis.datablock import names, option_section


# We have a collection of commonly used pre-defined block section names.
# If none of the names here is relevant for your calculation you can use any
# string you want instead.
cosmo = names.cosmological_parameters

def setup(options):
    return 1

def execute(block, config):
    #This function is called every time you have a new sample of cosmological and other parameters.
    #It is the main workhorse of the code. The block contains the parameters and results of any 
    #earlier modules, and the config is what we loaded earlier.

    section_lin = names.matter_power_lin # matter_power_lin                                                                                     
    k_lin, z_lin, P_lin = (block.get_grid(section_lin, "k_h", "z", "P_k"))
    block.replace_grid("matter_power_nl", "k_h", k_lin, "z", z_lin, "P_k", P_lin)

    #We tell CosmoSIS that everything went fine by returning zero
    return 0

def cleanup(config):
    # Usually python modules do not need to do anything here.
    # We just leave it in out of pedantic completeness.
    pass
