# -*- coding: utf-8 -*-
"""
Created on Thu May 16 14:40:37 2019

@author: karl

Goal: VFI using EGM for durable goods model
"""
#import os
import time

import numpy as np
#from itertools import product
#from scipy.interpolate import RectBivariateSpline as bispline
#from scipy.interpolate import UnivariateSpline as unispline
from scipy.optimize import minimize
#import scipy.sparse as sparse

from copy import deepcopy
import matplotlib.pyplot as plt

from numba import jit#, prange
#from quantecon.optimize.scalar_maximization import brent_max

@jit(nopython=True)
def linint(x, xgrid, v):    
    if x <= xgrid[0]:
        return v[0] + (x-xgrid[0])*(v[1]-v[0])/(xgrid[1]-xgrid[0])
    if x >= xgrid[-1]:
        return v[-1] + (x-xgrid[-1])*(v[-1]-v[-2])/(xgrid[-1]-xgrid[-2])

    x_i = np.searchsorted(xgrid, x)
    return v[x_i-1]+(x-xgrid[x_i-1])*(v[x_i]-v[x_i-1])/(xgrid[x_i]-xgrid[x_i-1])      

@jit(nopython=True)
def u(c, sigma):
    
    if c <= 0:
        c = 1e-20
    
    if sigma != 1:
        return c**(1-sigma)/(1-sigma)
    else:
        return float(np.log(c))

@jit(nopython=True)
def w_compute(ahatprime,
                v,
                Nepsilon, epsilon_val, epsilon_prob,
                Neta, eta_val, eta_prob,
                mhat_grid,
                beta, sigma,
                R, G, a_underbar):

    total = 0.0
    for epsilon_i in range(Nepsilon):
        for eta_i in range(Neta):
            mhatprime = epsilon_val[epsilon_i] + R/(G*eta_val[eta_i])*(ahatprime-a_underbar)+a_underbar
            
            total += beta*epsilon_prob[epsilon_i]*eta_prob[eta_i]*(G*eta_val[eta_i])**(1-sigma)*linint(mhatprime, mhat_grid, v)

    return total

def vfi_exogrid(v, parameters, printing):
    """
    Purpose: Compute one value function iteration using standard exogeneous grid method
    Input: v, parameters, printing
    Output: v_new, c_new
    """
    parameters = deepcopy(parameters)

    loop_start_time = time.time()

    #preferences
    beta = parameters['preferences']['beta']
    sigma = parameters['preferences']['sigma']
    R = parameters['technology']['R']
    G = parameters['technology']['G']
    a_underbar = parameters['technology']['a_underbar']
        
    #grids
    Nmhat = parameters['state_grids']['Nmhat']
    mhat_grid = parameters['state_grids']['mhat_grid']
    
    Nepsilon = parameters['shock_grids']['Nepsilon']
    epsilon_val = parameters['shock_grids']['epsilon_val']
    epsilon_prob = parameters['shock_grids']['epsilon_prob']
    Neta = parameters['shock_grids']['Neta']
    eta_val = parameters['shock_grids']['eta_val']
    eta_prob = parameters['shock_grids']['eta_prob']
    
    v_new = np.zeros(Nmhat)
    c_new = np.zeros(Nmhat)
    ahatprime_new = np.zeros(Nmhat)

    #Define a function that computes E (G*exp(nu))**(1-sigma)v(mhat'(ahat'))
    w = lambda x: w_compute(x,
                  v,
                  Nepsilon, epsilon_val, epsilon_prob,
                  Neta, eta_val, eta_prob,
                  mhat_grid,
                  beta, sigma,
                  R, G, a_underbar)
        
    #solve for c and aprime for every mhat in the grid
    for mhat_i in range(len(mhat_grid)):
        mhat = mhat_grid[mhat_i]
        
        #Here, we define the objective to be minimized (this equals -1 times the objective that should be maximized)
        objective = lambda x: -np.array([(u(mhat-x[0], sigma) + w(x[0]))])
        
        #Here, we perform the minmization: minimize the objective subject to be bounds given by budget and credit constraint
        #To be on the safe side, we do 5 numerical minimzations for 5 different starting values
        res = minimize(objective, x0=np.array([0.01*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])

        res2 = minimize(objective, x0=np.array([0.25*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        if -res2.fun[0]>-res.fun[0]:
            res = res2
        
        res3 = minimize(objective, x0=np.array([0.50*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        if -res3.fun[0]>-res.fun[0]:
            res = res3
            
        res4 = minimize(objective, x0=np.array([0.75*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        if -res4.fun[0]>-res.fun[0]:
            res = res4
            
        res5 = minimize(objective, x0=np.array([0.99*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        if -res5.fun[0]>-res.fun[0]:
            res = res5      
        
        #Here are our solution, and we update the value function accordingly
        ahatprime_new[mhat_i] = res.x[0]
        c_new[mhat_i] = mhat-ahatprime_new[mhat_i]
        v_new[mhat_i] = -res.fun[0]    
    
    return v_new, c_new


def infinite_horizon_vfi(v_guess, parameters, vfi_settings):
    """
    Purpose: Iterate value function iteration until convergence
    
    """
    
    parameters = deepcopy(parameters)
    mhat_grid = parameters['state_grids']['mhat_grid']

    etol = vfi_settings['etol']
    print_freq = vfi_settings['print_freq']
    
    v = v_guess
    
    error = 1000.0
    count = 0
    time_to_print = 0
    starting_time = time.time()

    while error > etol:
        comp_time = time.time()
        if comp_time - time_to_print > print_freq:
            printing = True
            time_to_print = comp_time
        else:
            printing = False
    
        v_new, c_new = vfi_exogrid(v, parameters, printing)
        
        error = np.max(np.abs(v_new-v))
        mean_error = np.mean(np.abs(v_new-v))
        if printing == True:
            print("Iteration =", count)
            print("Time elapsed = ", time.time()-starting_time)
            print("Error =", error)
            print("Mean Error =", mean_error)           
            f, ax = plt.subplots(1, 1, figsize=(6,6))
            h1 = ax.plot(mhat_grid, v_new, label = 'v(m)')
            h2 = ax.plot(mhat_grid, c_new, label = 'c(m)')
            ax.legend(handles = h1+h2, loc ='lower right')
            ax.set_xlabel("m", fontsize=14)
            plt.show()
            print("--------------------")
        
        v=v_new
        count = count + 1
        
    return v_new, c_new