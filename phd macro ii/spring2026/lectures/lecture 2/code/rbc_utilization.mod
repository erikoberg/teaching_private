var ahat yhat nhat khat kstarhat chat ihat what rhat deltahat uhat;
parameters alpha_val beta_val delta0_val eta1_val eta2_val theta_val varphi_val std_a_val rho_a_val R_ss_val CY_ss_val IY_ss_val;
varexo e;

load parameters.mat
alpha_val = alpha;
beta_val = beta;
delta0_val = delta0;
eta1_val = eta1;
eta2_val = eta2;
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

%utilization household optimality
rhat = eta2_val/eta1_val*uhat;

%depreciation rate
deltahat = eta1_val/delta0_val; 

%intratemporal household optimality
what = chat + varphi_val*nhat;

%intertemporal household optimality (Euler)
chat = -beta_val*R_ss_val*rhat(+1) - beta_val*eta1_val*delta0_val*uhat + chat(+1);

%Resource constraint
yhat = CY_ss_val*chat + IY_ss_val*ihat;

%Production function
yhat = ahat + alpha_val*kstarhat + (1-alpha_val)*nhat;

%Capital law of motion
khat = (1-delta0_val)*khat(-1) - eta1_val*uhat(-1) + delta0_val*ihat(-1);

%Firm optimaility 1
rhat = ahat - (1-alpha_val)*(kstarhat-nhat);

%Firm optimaility 2
what = ahat + alpha_val*(kstarhat-nhat);

%Capital utilization
kstarhat = uhat + khat;

end;

shocks;
var e = std_a_val^2;
end;

steady;
stoch_simul(order=1, nograph, hp_filter = 1600, irf =100);