clear all
clc

beta_val = 0.99;
sigma_val = 0.10; 
c_val = 0.2;
b_val = 0.4;
phi_val = 0.72;
lambda_val = 0.72;
a_val = 1.35;
rho_val = 0.5;
save parameters.mat

dynare dmp.mod;