var yhat chat nhat mchat what dhat pi ihat rhat nu;
parameters lambda_val beta_val sigma_val varphi_val phi_pi_val LS_val rho_nu_val std_nu_val;
varexo e_nu;


@#define nlag = 1

load parameters.mat
lambda_val = lambda;
beta_val = beta;
sigma_val = sigma;
varphi_val =varphi;
phi_pi_val = phi_pi;
LS_val = LS;
rho_nu_val = rho_nu;
std_nu_val = std_nu;


model(linear);

%shock processes
nu = rho_nu_val*nu(-1) + e_nu;

%Real interest rate
rhat = ihat-pi(+1);

%Intertemporal hh optimality
chat = - 1/sigma_val*rhat + EXPECTATION(-@{nlag})(chat(+1)) + nu;

%Intratemporal hh optimality
what = sigma_val*chat + varphi_val*nhat;

%Phillips
pi = beta_val*pi(+1) + lambda_val*mchat;

%Marginal cost
mchat = what;

%hh budget
chat = LS_val*(what+nhat)+(1-LS_val)*dhat;

%Goods clearing
chat = yhat;

%Labor clearing
yhat = nhat;

%Policy
ihat = phi_pi_val*pi;
end;

shocks;
var e_nu = std_nu_val^2;
end;

options_.noprint=1;

steady;

stoch_simul(order=1, nograph, irf =50);