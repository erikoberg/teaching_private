#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thursday March 26, 2020
@author: Erik Öberg

Goal: collect parameters values in a layered dictionary
"""
import numpy as np
from numpy.polynomial.hermite import hermgauss

def initialize_parameters(Nmhat = 100, Nmhat_upper = 15, mhat_grid_settings= [0.01, 10, 30],
                          Nahat = 100, Nahat_upper = 15, ahat_grid_settings= [0.01, 10, 30],
                          beta = 0.95, R=1.04, G=1.03, a_underbar=0.0, sigma=1.5,
                          sigma_epsilon=0.0440**(1/2), sigma_eta = 0.0212**(1/2)):
    
    mhat_low, mhat_middle, mhat_high = mhat_grid_settings
    ahat_low, ahat_middle, ahat_high = ahat_grid_settings
      
    mhat_grid = np.hstack([np.linspace(mhat_low, mhat_middle, Nmhat-Nmhat_upper), 
                           np.exp(np.linspace(np.log(mhat_middle), np.log(mhat_high), Nmhat_upper+1))[1:]])
    ahat_grid = np.hstack([np.linspace(ahat_low, ahat_middle, Nahat-Nahat_upper), 
                           np.exp(np.linspace(np.log(ahat_middle), np.log(ahat_high), Nahat_upper+1))[1:]])

    state_grids = dict(Nmhat=Nmhat, mhat_grid=mhat_grid,
                       Nahat=Nahat, ahat_grid=ahat_grid)
    
    #shock grids
    val, prob = hermgauss(5) 
    val = np.sqrt(2)*val
    prob = prob/np.sqrt(np.pi)
    Nepsilon = 5
    Neta = 5
    
    epsilon_prob = prob
    epsilon_val= np.exp(val*sigma_epsilon)
    epsilon_val = epsilon_val/np.sum(epsilon_prob*epsilon_val)

    eta_prob = prob
    eta_val = np.exp(val*sigma_eta)/np.sum(eta_prob*np.exp(val*sigma_eta))
    
    shock_grids = dict(Nepsilon=Nepsilon, epsilon_val=epsilon_val, epsilon_prob=epsilon_prob,
                       Neta=Neta, eta_val=eta_val, eta_prob=eta_prob)
    
    preferences = dict(beta=beta, sigma=sigma)  
    technology = dict(G=G, R=R, a_underbar=a_underbar)
 
    parameters = dict(preferences=preferences,
                      technology=technology,
                      state_grids=state_grids,
                      shock_grids=shock_grids)

    return parameters