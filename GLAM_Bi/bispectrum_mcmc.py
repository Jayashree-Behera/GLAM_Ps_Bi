import numpy as np
import matplotlib.pyplot as plt
import argparse
import os, sys
dir2 = os.path.abspath('')
dir1 = os.path.dirname(dir2)
if not dir1 in sys.path: sys.path.append(dir1)
from my_utils.mcmc.mcmc import RunMCMC
from my_utils.utils import *

import scipy.interpolate as interpolate
from scipy import integrate
import scipy.stats
import math

from tqdm import tqdm
import time
import emcee                    # for MCMC part
import warnings                 # for ignoring the warnings (not recommended)
warnings.filterwarnings('ignore')


Bk=np.load("../GLAM_Bi/bk_z0.50.npz")
Pk=np.load("../GLAM_Ps/pk_z0.50.npz")
k,pkm,pknm,pk,pkn=Pk['k'], Pk['pkm'].T[0],Pk['pknm'].T[0],Pk['pk'],Pk['pkn']
kk,bkm,bknm,bk,bkn=Bk['k'], Bk['bkm'].T[0], Bk['bknm'].T[0],Bk['bk'],Bk['bkn']

kg,bg,cov,_=cutslice(0.015,0.3,kk,bkm,bk)

def model(kk,alpha,f,b1,b2):
    res = Bi_meas(kk,k,pkm,pknm,alpha,f,b1,b2)
    return res

if __name__=="__main__":
    args = argparse.ArgumentParser()
    args.add_argument("--config",default=os.path.join("../my_utils","mcmc_params.yaml"))
    parsed_args = args.parse_args()
    
    mcmc_chain = RunMCMC(model,config_path = parsed_args.config)
    
    mcmc_chain.mcmc_run(kg,bg,cov)
    
    # module = config['model_path'][' module']
    # function = config['model_path']['function']
    # model = class_for_name(module,function)
    #print(mcmc_chain.config['params']['params_range'])