# -*- coding: utf-8 -*-
"""
Created on Thu Nov 30 15:24:55 2017

@author: eriob421
"""

from __future__ import division
import numpy as np
import scipy.misc as misc
import scipy.integrate as integrate
import scipy.special as special
import matplotlib.pyplot as plt


#parameters
b = 0.4;           # workers bargaining power
r = .05**(1/12);    # discount rate
sigma = .0081;            # separation rate
lam_e = 0.05;            #offer rate unemployed
lam_u = 0.4;        #offer rate employed
N_f = 1000;          #number of firms
N_w = 10000;         #number of workers

#Offer distribution
mu_offer = 3;
sigma_offer = 1;

def integrand(x):
    return integrate.quad(lambda z:  (1-special.ndtr((z-mu_offer)/sigma_offer))/(r + sigma + lam_e*(1-special.ndtr((z-mu_offer)/sigma_offer))), x*sigma_offer+mu_offer, 1000)[0]

#Find reservation wage by bisection
w_l = b;
w_h = 5*b;
while w_h-w_l > 10**(-5):
    w_r = (w_h+w_l)/2;
    print w_r
    LHS = w_r-b;
    RHS = (lam_u-lam_e)*integrand(w_r);
    
    if LHS>RHS:
        w_h = w_r;
    if LHS<RHS:
        w_l = w_r;

#Find G and g distribution
def G(x):
    if x<w_r:
        return 0;
    if x >= w_r:
        return (special.ndtr((x-mu_offer)/sigma_offer)-special.ndtr((w_r-mu_offer)/sigma_offer))/((1-special.ndtr((w_r-mu_offer)/sigma_offer))*(1+lam_e/sigma*(1-special.ndtr((x-mu_offer)/sigma_offer))))

def g(x):
    return misc.derivative(G,x)

#Plot f and g
x = np.arange(mu_offer-3, mu_offer+4, 0.01);
y_1 = np.array([(misc.derivative(lambda z: special.ndtr(z), (z-mu_offer)/sigma_offer)) for z in x]);
y_2 = np.array([g(z)*(z>w_r) for z in x]);

plt.figure(figsize=(12,6))
f_line = plt.plot(x, y_1, label='f(w)')
g_line = plt.plot(x, y_2, label='g(w)')
plt.legend(fontsize='xx-large')
plt.savefig('bm_density.pdf')
plt.show()