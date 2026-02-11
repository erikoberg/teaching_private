var yhat chat nhat mchat what dhat pi ihat rhat nu a;
parameters lambda_val beta_val varphi_val phi_pi_val LS_val rho_nu_val std_nu_val rho_a_val std_a_val;
varexo e_nu e_a;


@#define nlag = 1

load parameters.mat
lambda_val = lambda;
beta_val = beta;
varphi_val =varphi;
phi_pi_val = phi_pi;
LS_val = LS;
rho_nu_val = rho_nu;
std_nu_val = std_nu;
rho_a_val = rho_a;
std_a_val = std_a;


model(linear);

%shock processes
nu = rho_nu_val*nu(-1) + e_nu;
a = rho_a_val*a(-1) + e_a;

%Real interest rate
rhat = ihat-pi(+1);

%Intertemporal hh optimality
chat = - rhat + chat(+1);

%Intratemporal hh optimality
what = chat + varphi_val*nhat;

%Phillips
pi = beta_val*pi(+1) + lambda_val*mchat;

%Marginal cost
mchat = what - a;

%hh budget
chat = LS_val*(what+nhat)+(1-LS_val)*dhat;

%Goods clearing
chat = yhat;

%Labor clearing
yhat = nhat + a;

%Policy
ihat = phi_pi_val*pi + nu;
end;

shocks;
var e_nu = std_nu_val^2;
var e_a = std_a_val^2;
end;

options_.noprint=1;

steady;

stoch_simul(order=1, nograph, irf =50);