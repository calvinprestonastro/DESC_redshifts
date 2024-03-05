# needs to get the Pl, Pnl from the block
# also get the Amod values

from builtins import range
from builtins import object
import numpy as np
try:
    import scipy.interpolate
except ImportError:
    sys.stderr.write(
        "The OWLS baryon power code requires the scipy python module\n")
    sys.stderr.write("but it could not be found.  This code will fail.\n")
    raise ImportError(
        "Require scipy module to run baryon code.  Could not find it.")

import os

def modify(k, z, P, k_lin, z_lin, P_lin, Amod):  #modify(Pl,Pnl,Amod):
    
    #print(Amod)
    #print(P)
    #print("now lengths")
    #print(len(Amod))
    #print(len(P))
    #print("now dimensions")
    #print(np.shape(Amod))
    #print(np.shape(P))
    # Pm_new = (GmodK(k, kc, D, n))*(P) 
    print("Done")
    Pm_new = P_lin + Amod*(P-P_lin)
    return Pm_new


#and give back the Pm_new and A
