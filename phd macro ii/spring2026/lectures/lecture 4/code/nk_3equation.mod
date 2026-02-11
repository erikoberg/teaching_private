var yhat pi ihat nu;
parameters kappa_val beta_val phi_pi_val rho_nu_val std_nu_val;
varexo e;

load parameters.mat
kappa_val = kappa;
beta_val = beta;
phi_pi_val = phi_pi;
rho_nu_val = rho_nu;
std_nu_val = std_nu;


model(linear);
%shock process
nu = rho_nu_val*nu(-1) + e;

%Dynamics IS
yhat = - (ihat-pi(+1)) + yhat(+1);

%Phillips
pi = beta_val*pi(+1) + kappa_val*yhat;

%Policy
ihat = phi_pi_val*pi + nu;
end;

shocks;
var e = std_nu_val^2;
end;

steady;
stoch_simul(order=1, nograph, irf =50);