var ahat yhat nhat khat chat ihat what rhat;
parameters alpha_val beta_val delta_val sigma_val theta_val varphi_val std_a_val rho_a_val R_ss_val CY_ss_val IY_ss_val;
varexo e;

load parameters.mat
alpha_val = alpha;
beta_val = beta;
delta_val = delta;
sigma_val = sigma;
theta_val = theta;
varphi_val = varphi;
std_a_val = std_a;
rho_a_val = rho_a;

R_ss_val = R_ss;
CY_ss_val = CY_ss;
IY_ss_val = IY_ss;

model(linear);
%productivity process
ahat = rho_a_val*ahat(-1) + e;

%intratemporal household optimality
what = sigma_val*chat + varphi_val*nhat;

%intertemporal household optimality (Euler)
chat = -1/sigma_val*(R_ss_val/(R_ss_val+(1-delta_val)))*rhat(+1) + chat(+1);

%Resource constraint
yhat = CY_ss_val*chat + IY_ss_val*ihat;

%Production function
yhat = ahat + alpha_val*khat + (1-alpha_val)*nhat;

%Capital law of motion
khat = (1-delta_val)*khat(-1) + delta_val*ihat(-1);

%Firm optimaility 1
rhat = ahat - (1-alpha_val)*(khat-nhat);

%Firm optimaility 2
what = ahat + alpha_val*(khat-nhat);

end;

shocks;
var e = std_a_val^2;
end;

steady;
stoch_simul(order=1, nograph, hp_filter = 1600, irf =100);