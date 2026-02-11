# -*- coding: utf-8 -*-
"""
Created on Thu Nov 30 15:24:55 2017

@author: eriob421
"""

from __future__ import division
import numpy as np



#parameters
beta = 0.052;           # workers bargaining power
delta = .99**(1/12);    # discount rate
lam = .407;             # matching parameter
rho = .9895;            # persistence of productivity process
sep = .0081;            # separation rate
sigma = .0034;          # variance of innovations in productivity process
b   = .955;             # value of nonmarket activity
c = 0.1;                #cost of creating vacancy
A = 1;                  #matching function efficiency 

#grid and transition function using Tauchen-Haussey
p_grid =  np.array([0.7,1,1.3]);
T = np.array([[0.8, 0.2, 0],
              [0.1, 0.8, 0.1],
              [0, 0.2, 0.8]]);

#intialize value functions
J = np.zeros(3);
V = np.zeros(3);
U = np.zeros(3);
W = np.zeros(3);

J_new = np.zeros(3);
V_new = np.zeros(3);
U_new = np.zeros(3);
W_new = np.zeros(3);

w = np.zeros(3);

theta_h = [15,15,15];
theta_l = [5.13,5.13,5.13];
theta = (np.array(theta_h)+np.array(theta_l))/2;

#functions
def job_filing(x):
    return A*(1-lam)*x**(-lam)

def job_finding(x):
    return A*lam*x**(1-lam)


#Bisection
while np.max(np.array(theta_h) - np.array(theta_l)) > 10**(-5):
    w = beta * p_grid  + (1-beta)*b+ c *beta*theta;
    
    dist = 1;
    #loop
    while dist > 10**(-5):
        for i in [0,1,2]:
            J_new[i] = p_grid[i] - w[i] + delta *((1-sep) * np.dot(T[i],J) + sep * np.dot(T[i],V));
            V_new[i] = -c + delta *(job_filing(theta[i]) * np.dot(T[i],J)  + (1-job_filing(theta[i])) * np.dot(T[i],V));
            U_new[i] = b + delta * (job_finding(theta[i])*np.dot(T[i],W) + (1-job_finding(theta[i]))*np.dot(T[i],U));
            W_new[i] = w[i] + delta * ( sep*np.dot(T[i],U) + (1-sep)*np.dot(T[i],W));
            
        dist = np.max(abs(J-J_new) + abs(V-V_new) + abs(U-U_new) + abs(W-W_new));
        
        V = np.array(V_new);
        J = np.array(J_new);
        U = np.array(U_new);
        W = np.array(W_new);

    for i in [0,1,2]:
        if V[i]>0:
            theta_l[i] = theta[i];
        if V[i]<0:
            theta_h[i] = theta[i];

    theta = (np.array(theta_h)+np.array(theta_l))/2;    
    print 'theta', theta    
#            
#theta = np.array([1,1,1]);
#theta_old = np.array([2,2,2]);
#while np.max(np.abs(theta-theta_old)) > 10**(-5):
#    theta_old = theta;
#    for i in [0,1,2]:
#        theta[i] = (c/(A*lam* delta** np.dot(T[i],J)))**(1/(1-lam));
#        w[i] = beta * p_grid[i]  + (1-beta)*b+ c *beta*theta[i];
#    
#    dist = 1;
#    #loop
#    while dist > 10**(-5):
#        for i in [0,1,2]:
#            J_new[i] = p_grid[i] - w[i] + delta *((1-sep) * np.dot(T[i],J));
#            U_new[i] = b + delta * (job_finding(theta[i])*np.dot(T[i],W) + (1-job_finding(theta[i]))*np.dot(T[i],U));
#            W_new[i] = w[i] + delta * ( sep*np.dot(T[i],U) + (1-sep)*np.dot(T[i],W));
#            
#        dist = np.max(abs(J-J_new) + abs(V-V_new) + abs(U-U_new) + abs(W-W_new));
#        
#        V = np.array(V_new);
#        J = np.array(J_new);
#        U = np.array(U_new);
#        W = np.array(W_new);
# 
#    print 'theta', theta    
