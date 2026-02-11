# -*- coding: utf-8 -*-
"""
Created on Thursday March 16, 2020
@author: Erik Öberg

Goal: VFI for standard buffer-stock savings 
Uses either standard exogeneous grid or endogeneous-grid method by Carroll (EL, 2006)
"""
import time
import numpy as np
from scipy.optimize import minimize
from copy import deepcopy
import matplotlib.pyplot as plt
from numba import jit, prange

@jit(nopython=True)
def linint(x, xgrid, v):  
    """
    Purpose: Linear interpolation/extrapolation
    Input: point x, grid xgrid, function v
    Output: point value v(x)
    """
    
    #If x is outside grid, do linear extrapolation
    if x <= xgrid[0]:
        return v[0] + (x-xgrid[0])*(v[1]-v[0])/(xgrid[1]-xgrid[0])
    if x >= xgrid[-1]:
        return v[-1] + (x-xgrid[-1])*(v[-1]-v[-2])/(xgrid[-1]-xgrid[-2])

    #find the nearest value below x in the grid xgrid
    x_i = np.searchsorted(xgrid, x)
    return v[x_i-1]+(x-xgrid[x_i-1])*(v[x_i]-v[x_i-1])/(xgrid[x_i]-xgrid[x_i-1])      

@jit(nopython=True)
def u(c, sigma):
    """
    Purpose: Compute contemporaneous utility of consumption choice c using CRRA utility function
    Input: c, sigma
    Output: u(c)
    """
    
    #If c is nonpositive, set it to very small positive number
    if c <= 0:
        c = 1e-20
    
    #if sigma=1, use u(c)=log(c)
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
    """
    Purpose: Compute expected continuation value given a savings choice ahat'
    Input: ahatprime, parameters
    Output: w
    """
    
    w = 0.0
    #compute expected value by looping over all future values of epsilon and eta
    for epsilon_i in range(Nepsilon):
        for eta_i in range(Neta):
            #Compute mhat' given epsilon and eta
            mhatprime = epsilon_val[epsilon_i] + R/(G*eta_val[eta_i])*(ahatprime-a_underbar)+a_underbar
            
            #Compute contribution of this particular epsilon and eta to the expected continuation value
            #Note, since v is computed on a discrete grid, we need to interpolate this function for values in between the grid points
            w += beta*epsilon_prob[epsilon_i]*eta_prob[eta_i]*(G*eta_val[eta_i])**(1-sigma)*linint(mhatprime, mhat_grid, v)
            
    return w

def vfi_exogrid(v, parameters, printing):
    """
    Purpose: Compute one value function iteration using standard exogeneous grid method
    Input: v, parameters, printing
    Output: v_new, c_new
    """
    parameters = deepcopy(parameters)

    #preferences and technology
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

    #Define a function that computes w(ahat') = E (G*exp(nu))**(1-sigma)v(mhat'(ahat'))
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
        
        #Here, we define the objective to be minimized: -(u(m-ahat')+w(ahat'))
        #Note that this objective equals -1 times the objective that should be maximized
        objective = lambda x: -np.array([(u(mhat-x[0], sigma) + w(x[0]))])
        
        #Here, we perform the minmization: minimize the objective subject to be bounds given by budget and credit constraint
        #To be on the safe side, we do 3 numerical minimzations for 3 different starting values
        res = minimize(objective, x0=np.array([0.01*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        
        res2 = minimize(objective, x0=np.array([0.50*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        if -res2.fun[0]>-res.fun[0]:
            res = res2
            
        res3 = minimize(objective, x0=np.array([0.99*mhat]), method = 'L-BFGS-B', bounds=[(0, mhat)])
        if -res3.fun[0]>-res.fun[0]:
            res = res3      
        
        #Here are our solution, and we update the value function accordingly
        ahatprime_new[mhat_i] = res.x[0]
        c_new[mhat_i] = mhat-ahatprime_new[mhat_i]
        v_new[mhat_i] = -res.fun[0]    
    
    return v_new, c_new


@jit(nopython=True)
def w_compute_at_point(ahat_i,
                       v,
                       Nepsilon, epsilon_val, epsilon_prob,
                       Neta, eta_val, eta_prob,
                       mhat_grid, ahat_grid,
                       beta, sigma,
                       R, G, a_underbar):
    """
    Purpose: Compute continuation values for a point on the savings grid
    Input: savings point ahat_i, value function v, parameters
    Output: continuation value w
    """    
    
    
    w = 0.0
    #compute expected value by looping over all future values of epsilon and eta
    for epsilon_i in range(Nepsilon):
        for eta_i in range(Neta):
            #Compute mhat' given epsilon and eta
            mhatprime = epsilon_val[epsilon_i] + R/(G*eta_val[eta_i])*(ahat_grid[ahat_i]-a_underbar)+a_underbar
            
            #Compute contribution of this particular epsilon and eta to the expected continuation value
            #Note, since v is computed on a discrete grid, we need to interpolate this function for values in between the grid points
            w += beta*epsilon_prob[epsilon_i]*eta_prob[eta_i]*(G*eta_val[eta_i])**(1-sigma)*linint(mhatprime, mhat_grid, v)
                
    return w



@jit(nopython=True, parallel=True)
def w_compute_array(v,
                    Nepsilon, epsilon_val, epsilon_prob,
                    Neta, eta_val, eta_prob,
                    mhat_grid, ahat_grid,
                    beta, sigma,
                    R, G, a_underbar):
    """
    Purpose: Compute continuation values on the savings grid ahat_grid
    Input: value function v, parameters
    Output: continuation value w
    """    
    
    Na = len(ahat_grid)
    w = np.zeros(Na)
        
    #compute continuation value for each point along the grid
    for ahatprime_i in prange(Na):
        w[ahatprime_i] = w_compute_at_point(ahatprime_i,
                                            v,
                                            Nepsilon, epsilon_val, epsilon_prob,
                                            Neta, eta_val, eta_prob,
                                            mhat_grid, ahat_grid,
                                            beta, sigma,
                                            R, G, a_underbar)
    return w

@jit(nopython = True)
def v_compute_at_point(ahatprime_i, w,
                       mhat_grid, ahat_grid,
                       Nmhat, Nahat,
                       sigma):
    
    if ahatprime_i >0 and ahatprime_i < Nahat-1:
        w_derivative = 0.5*(w[ahatprime_i]-w[ahatprime_i-1])/(ahat_grid[ahatprime_i]-ahat_grid[ahatprime_i-1])+\
                       0.5*(w[ahatprime_i+1]-w[ahatprime_i])/(ahat_grid[ahatprime_i+1]-ahat_grid[ahatprime_i])

                       
    if ahatprime_i == 0:
        w_derivative = (w[ahatprime_i+1]-w[ahatprime_i])/(ahat_grid[ahatprime_i+1]-ahat_grid[ahatprime_i])
    if ahatprime_i == Nahat-1:
        w_derivative = (w[ahatprime_i]-w[ahatprime_i-1])/(ahat_grid[ahatprime_i]-ahat_grid[ahatprime_i-1])
    
    c_temp = w_derivative**(-(1/sigma))
    mhat_temp = c_temp + ahat_grid[ahatprime_i]
    
    return c_temp, mhat_temp


@jit(nopython=True)
def upper_envelope(mhat_temp_array,
                   w,
                   Nmhat, Nahat,
                   mhat_grid, ahat_grid,
                   sigma):
    """
    Purpose: 1) check whether solution abides the credit constraint - if not, set c=m, 2) For each point on mhat_temp_array, compute where on the ahat_grid the optimal savings choice lies
    Input: cash on hand endogeneous grid mhat_temp_array, w, parameters
    Output: value function v, consumption function c
    """    
    
    v = np.ones(Nmhat)*(-1)*np.inf
    c = np.zeros(Nmhat)
    
    #Deal with borrowing constraint
    for j in range(Nmhat):
        if mhat_grid[j] <= mhat_temp_array[0]:
            c[j] = mhat_grid[j]
            v[j] = u(c[j], sigma) + w[0]
    
    
    #For each point on mhat_temp_array, compute where on the ahat_grid the optimal savings choice lies
    #If the savings choice lies between two points on ahat_grid, calculate weighted average
    for i in range(Nahat-1):
        for j in range(Nmhat):
            if ((mhat_grid[j] > mhat_temp_array[i]) and (mhat_grid[j] <= mhat_temp_array[i+1])):              
                ahatprime_temp = ahat_grid[i] + (ahat_grid[i+1]-ahat_grid[i])*\
                                 (mhat_grid[j]-mhat_temp_array[i])/(mhat_temp_array[i+1]-mhat_temp_array[i])
                
                c_temp = mhat_grid[j]-ahatprime_temp
                v_temp = u(c_temp, sigma) + linint(ahatprime_temp, ahat_grid, w)

                
                if v_temp > v[j]:
                    v[j] = v_temp
                    c[j] = c_temp
    
    #Just an error checking 
    if np.isinf(v).any():
        print("Something is wrong in upper envelope")
        
    return v, c


@jit(nopython=True)
def v_compute(w,
              Nmhat, Nahat,
              mhat_grid, ahat_grid,
              sigma):

    """
    Purpose: Compute consumption function and new value function using EGM
    Input: continuation value w, parameters
    Output: value function v, consumption function c
    """    
       
    v = np.zeros(Nmhat)
    c = np.zeros(Nmhat)
    mhat_temp_array = np.empty(Nmhat)
    
    #For each point on the savings grid, back out a cash-on-hand mhat consistent with the savings assuming
    #an interior solution 
    for ahatprime_i in range(Nahat):
        c_temp, mhat_temp =  v_compute_at_point(ahatprime_i, w,
                                                mhat_grid, ahat_grid,
                                                Nmhat, Nahat,
                                                sigma)

        mhat_temp_array[ahatprime_i] = mhat_temp

    #This function does two things: 
    #1) check whether solution abides the credit constraint - if not, set c=m
    #2) For each point on mhat_temp_array, compute where on the ahat_grid the optimal savings choice lies
    v, c = upper_envelope(mhat_temp_array,
                          w,
                          Nmhat, Nahat,
                          mhat_grid, ahat_grid,
                          sigma)

    return v, c


def vfi_endogrid(v, parameters, printing):
    """
    Purpose: Compute one value function iteration using endogeneous grid method
    Input: v, parameters, printing
    Output: v, c
    """
    parameters = deepcopy(parameters)

    #preferences and technology
    beta = parameters['preferences']['beta']
    sigma = parameters['preferences']['sigma']
    R = parameters['technology']['R']
    G = parameters['technology']['G']
    a_underbar = parameters['technology']['a_underbar']

    
    #grids
    Nmhat = parameters['state_grids']['Nmhat']
    mhat_grid = parameters['state_grids']['mhat_grid']
    Nahat = parameters['state_grids']['Nahat']
    ahat_grid = parameters['state_grids']['ahat_grid']   
   
    Nepsilon = parameters['shock_grids']['Nepsilon']
    epsilon_val = parameters['shock_grids']['epsilon_val']
    epsilon_prob = parameters['shock_grids']['epsilon_prob']
    Neta = parameters['shock_grids']['Neta']
    eta_val = parameters['shock_grids']['eta_val']
    eta_prob = parameters['shock_grids']['eta_prob']
    
    #Compute continuation values on the savings grid ahat_grid            
    w = w_compute_array(v,
                        Nepsilon, epsilon_val, epsilon_prob,
                        Neta, eta_val, eta_prob,
                        mhat_grid, ahat_grid,
                        beta, sigma,
                        R, G, a_underbar)
        
    #EGM to compute v and c, given continutation values
    v, c = v_compute(w,
                     Nmhat, Nahat,
                     mhat_grid, ahat_grid,
                     sigma)
    
    return v, c


def infinite_horizon_vfi(v_guess, parameters, vfi_settings, method):
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
    
        if method == "exogeneous_grid":
            v_new, c_new = vfi_exogrid(v, parameters, printing)
        if method == "endogeneous_grid":
            v_new, c_new = vfi_endogrid(v, parameters, printing)
        
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