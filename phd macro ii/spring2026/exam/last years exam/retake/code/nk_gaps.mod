var ytilde pi ihat rhat rnat nu a;
parameters kappa_val beta_val phi_pi_val rho_nu_val std_nu_val;
varexo e_nu;

load parameters.mat
kappa_val = kappa;
beta_val = beta;
phi_pi_val = phi_pi;
rho_nu_val = rho_nu;
std_nu_val = std_nu;
rho_a_val = rho_a;
std_a_val = std_a;


model(linear);
%shock process
nu = rho_nu_val*nu(-1) + e_nu;

%Dynamics IS
ytilde = - (rhat-rnat) + ytilde(+1);

%Phillips
pi = beta_val*pi(+1) + kappa_val*ytilde + nu;

%Real interest rate
rhat = ihat - pi(+1);

%Natural real interest rate
rnat = -(1-rho_a_val)*a;

%Policy
ihat = phi_pi_val*pi;
end;

shocks;
var e_nu = std_nu_val^2;
end;

steady;
stoch_simul(order=1, nograph, irf =50);