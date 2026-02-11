"""
Created on Wed Mar 25 08:48:13 2020

@author: erik

We solve the following standard buffer-stock savings problem:
v(m) = max_[c, a'] c**(1-sigma)/(1-sigma) + E (G*exp(nu))**(1-sigma)*v(m')
s.t.
a' = m-c
m' = exp(epsilon) + R/(G*exp(nu))*a'
a' >= a_underbar
c >= 0
where epsilon and nu are normally distributed and parameters values are standard.

We note that this problem may be rewritten
v(m) = max_[c, ahat'] c**(1-sigma)/(1-sigma) + E (G*exp(nu))**(1-sigma)*v(m')
s.t.
ahat' = mhat-c
mhat' = exp(epsilon) + R/(G*exp(nu))*(a'.ahat) + a_underbar
ahat' >= 0
c >= 0
where
ahat = a + a_underbar
mhat = m + a_underbar
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

#Parameter values, risk parameters taken from Gournichas-Parker (Ecmtra, 2002)
beta = 0.95
R = 1.04
G = 1.03
a_underbar = 0.0
sigma = 1.5
sigma_epsilon = 0.0440**(1/2) 
sigma_eta = 0.0212**(1/2)

#Computation settings
vfi_settings = dict(etol = 1e-6, print_freq=5)
mhat_grid_settings = [0.1, 10, 30+a_underbar]
Nmhat = 100
Nmhat_upper = 20

#############
##Basline###
############
#initialize parameters
#In the parameters dictionary, all parameters are saved in suitably named subdictionaries
parameters = initialize_parameters(Nmhat, Nmhat_upper, mhat_grid_settings,
                                   beta, R, G, a_underbar, sigma,
                                   sigma_epsilon, sigma_eta)

#Initial guess of value function
v_guess = np.array([np.log(mhat_val) for mhat_val in parameters['state_grids']['mhat_grid']])

#Do value function iteration
v, c = infinite_horizon_vfi(v_guess, parameters, vfi_settings)


######################
##Perfect Foresight###
######################
#initialize parameters
a_underbar_pf = 1/(1-G/R) #natural borrowing limit
sigma_epsilon_pf = 0.0
sigma_eta_pf = 0.0

#Computation settings
m_grid_settings_pf = [0.1, 10, 30+a_underbar_pf]

parameters_pf = initialize_parameters(Nmhat, Nmhat_upper, m_grid_settings_pf,
                                      beta, R, G, a_underbar_pf, sigma,
                                      sigma_epsilon_pf, sigma_eta_pf)

#Initial guess of value function
v_guess_pf = np.array([np.log(mval) for mval in parameters_pf['state_grids']['m_grid']])

#Do value function iteration
v_pf, c_pf = infinite_horizon_vfi(v_guess_pf, parameters_pf, vfi_settings)




###########
###Plots###
###########
m_grid_adj = parameters['state_grids']['m_grid']-a_underbar
m_grid_adj_pf = parameters_pf['state_grids']['m_grid']-a_underbar_pf

exp_mprime = 1+R/G*(m_grid_adj-c)
exp_delta_mprime = 1+R/G*(m_grid_adj-c)-m_grid_adj

f, ax = plt.subplots(1, 1, figsize=(10,10))
h1 = ax.plot(m_grid_adj, c, color="blue", linestyle = '-', label = "cons. function, c(m)", lw=2)
h2 = ax.plot(m_grid_adj, m_grid_adj-c, color="red", linestyle = '-', label = "sav. function, a(m)=m-c(m)", lw=2)
h3 = ax.plot(m_grid_adj, m_grid_adj, color="black", linestyle = '--', label = "45* line", lw=2)
h4 = ax.plot(m_grid_adj, 1+R/G*(m_grid_adj-c), color="green", linestyle = '-', label = "Exp. c.o.h., E(m'|a(m))", lw=2)
h5 = ax.plot(np.ones(10)*m_grid_adj[np.abs(exp_delta_mprime).argmin()], np.linspace(0,10, 10), color="black", linestyle = ':', label = "Target", lw=2)
h6 = ax.plot(m_grid_adj_pf, c_pf, color="magenta", linestyle = '-', label = "c(m), perfect foresight with nat. bor. limit", lw=2)

ax.legend(handles = h1+h2+h3+h4+h6, loc ='lower right')
ax.set_xlim([0,5])
ax.set_ylim([0,5])
ax.set_xlabel("m", fontsize=14)
plt.savefig(output_folder + "consumption_function.pdf")
plt.show()
