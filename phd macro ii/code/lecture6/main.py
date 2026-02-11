"""
Created on Wed Mar 25 08:48:13 2020
@author: Erik Öberg

We solve the following standard buffer-stock savings problem:
v(m) = max_[c, a'] c**(1-sigma)/(1-sigma) + E (G*exp(eta))**(1-sigma)*v(m')
s.t.
a' = m-c
m' = epsilon' + R/(G*eta')*a'
a' >= a_underbar
c >= 0
where epsilon and nu are normally distributed and parameters values are standard.

We note that this problem may be rewritten
v(m) = max_[c, ahat'] c**(1-sigma)/(1-sigma) + E (G*exp(eta))**(1-sigma)*v(m')
s.t.
ahat' = mhat-c
mhat' = epsilon' + R/(G*eta')*(ahat'-a_underbar) + a_underbar
ahat' >= 0
c >= 0
where
ahat = a + a_underbar
mhat = m + a_underbar

Notes:
1) You can choose between using standard VFI with exogeneous grids or the endogeneous-grid method by Carroll (El, 2006)
2) In vfi.py, most functions are jitted (parallellized and executed in C), which speeds up the computations
3) I assume that epsilon and eta are log-normally distributed. This is equivalent to assuming that
   epsilon and eta are normally distributed and replacing the terms with exp(epsilon) and exp(eta)
   in the consumption-savings problem
"""

#import functions
from set_parameters import initialize_parameters
from vfi import infinite_horizon_vfi

import numpy as np
import os
import matplotlib.pyplot as plt

#Preliminaries
output_folder = "output/"
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

###################
##Baseline model###
###################

#Parameter values, risk parameters taken from Gournichas-Parker (Ecmtra, 2002)
beta = 0.95
R = 1.04
G = 1.03
a_underbar = 0.0
sigma = 1.5
sigma_epsilon = 0.0440**(1/2) 
sigma_eta = 0.0212**(1/2)

#Computation settings
vfi_settings = dict(etol = 1e-6, print_freq=1)
mhat_grid_settings = [0.1, 10, 30+a_underbar]
ahat_grid_settings = [0, 10, 30+a_underbar] #The ahat grid is only used for the EGM method
Nmhat = 100
Nmhat_upper = 20
Nahat = 100
Nahat_upper = 20
method = "endogeneous_grid" #"exogeneous_grid" or "endogeneous_grid"

#initialize parameters
#In the parameters dictionary, all parameters are saved in suitably named subdictionaries
parameters = initialize_parameters(Nmhat, Nmhat_upper, mhat_grid_settings,
                                   Nahat, Nahat_upper, ahat_grid_settings,
                                   beta, R, G, a_underbar, sigma,
                                   sigma_epsilon, sigma_eta)

#Initial guess of value function
v_guess = np.array([np.log(mhat_val) for mhat_val in parameters['state_grids']['mhat_grid']])

#Do value function iteration
print("VFI baseline started")
v, c = infinite_horizon_vfi(v_guess, parameters, vfi_settings, method)
print("VFI baseline finished")

######################
##Perfect Foresight###
######################

#parameters values
a_underbar_pf = 1/(1-G/R) #natural borrowing limit
sigma_epsilon_pf = 0.0
sigma_eta_pf = 0.0

#Computation settings
mhat_grid_settings_pf = [0.1, 10, 30+a_underbar_pf]
ahat_grid_settings_pf = [0, 10, 30+a_underbar_pf]

#initialize parameters
parameters_pf = initialize_parameters(Nmhat, Nmhat_upper, mhat_grid_settings_pf,
                                      Nahat, Nahat_upper, ahat_grid_settings_pf,
                                      beta, R, G, a_underbar_pf, sigma,
                                      sigma_epsilon_pf, sigma_eta_pf)

#Initial guess of value function
v_guess_pf = np.array([np.log(mhat_val) for mhat_val in parameters_pf['state_grids']['mhat_grid']])

#Do value function iteration
print("VFI perfect foresight started")
v_pf, c_pf = infinite_horizon_vfi(v_guess_pf, parameters_pf, vfi_settings, method)
print("VFI perfect foresight finished")


#################################
##Plot of consumption function###
#################################
mhat_grid = parameters['state_grids']['mhat_grid']-a_underbar
mhat_grid_pf = parameters_pf['state_grids']['mhat_grid']-a_underbar_pf

exp_mprime = np.sum(parameters['shock_grids']['epsilon_prob']*parameters['shock_grids']['epsilon_val'])\
            +R/G*(mhat_grid-c)*np.sum(parameters['shock_grids']['eta_prob']*(1/parameters['shock_grids']['eta_val']))
exp_delta_mprime = exp_mprime-mhat_grid

f, ax = plt.subplots(1, 1, figsize=(10,10))
h1 = ax.plot(mhat_grid, c, color="blue", linestyle = '-', label = "cons. function, c(m)", lw=2)
h2 = ax.plot(mhat_grid, mhat_grid-c, color="red", linestyle = '-', label = "sav. function, a(m)=m-c(m)", lw=2)
h3 = ax.plot(mhat_grid, mhat_grid, color="black", linestyle = '--', label = "45* line", lw=2)
h4 = ax.plot(mhat_grid, 1+R/G*(mhat_grid-c), color="green", linestyle = '-', label = "Exp. c.o.h., E(m'|a(m))", lw=2)
h5 = ax.plot(np.ones(10)*mhat_grid[np.abs(exp_delta_mprime).argmin()], np.linspace(0,10, 10), color="black", linestyle = ':', label = "Target", lw=2)
h6 = ax.plot(mhat_grid_pf, c_pf, color="magenta", linestyle = '-', label = "c(m), perfect foresight", lw=2)

ax.legend(handles = h1+h2+h3+h4+h6, loc ='lower right', fontsize=14)
ax.set_xlim([0,5])
ax.set_ylim([0,5])
ax.set_xlabel("m", fontsize=16)
ax.xaxis.set_tick_params(labelsize=16)
ax.yaxis.set_tick_params(labelsize=16)

plt.savefig(output_folder + "consumption_function.pdf")
plt.show()