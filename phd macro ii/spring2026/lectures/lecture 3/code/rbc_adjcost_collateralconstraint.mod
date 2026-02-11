var ahat yhat nhat khat chat ihat what rhat Rhat logQhat qhat muhat;
parameters alpha_val beta_val delta_val  theta_val varphi_val phi_val xi_val std_a_val rho_a_val R_ss_val CY_ss_val IY_ss_val Q_ss_val;
varexo e;

load parameters.mat
alpha_val = alpha;
beta_val = beta;
phi_val = phi;
delta_val = delta;
theta_val = theta;
varphi_val = varphi;
xi_val = xi;
std_a_val = std_a;
rho_a_val = rho_a;

R_ss_val = R_ss;
Q_ss_val = Q_ss;
CY_ss_val = CY_ss;
IY_ss_val = IY_ss;
KN_ss_val = KN_ss;

model(linear);
%productivity process
ahat = rho_a_val*ahat(-1) + e;

%intratemporal household optimality
what = chat + varphi_val*nhat;

%Risk free interest rate
rhat  =-logQhat; 

%Household capital optimality (Euler)
chat  = -rhat + chat(+1); 

%Firm constraint
ihat = qhat + khat;

%Firm optimaility 1
what = ahat + alpha_val*(khat-nhat);

%Firm optimaility 2
Rhat = ahat - (1-alpha_val)*(khat-nhat) - phi_val*delta_val^2/R_ss_val*(ihat-khat);

%Firm optimaility 3
qhat = -rhat + xi_val/delta_val*Q_ss_val*R_ss_val*Rhat(+1) + Q_ss_val*(delta_val-xi_val)*muhat(+1)+Q_ss_val*(1-xi_val)*qhat(+1);

%Firm optimaility 4
qhat = phi_val*xi_val*(ihat-khat)+(1-xi_val/delta_val)*muhat;

%Resource constraint
yhat = CY_ss_val*chat + IY_ss_val*ihat;

%Production function
yhat = ahat + alpha_val*khat + (1-alpha_val)*nhat;

%Capital law of motion
khat = (1-delta_val)*khat(-1) + delta_val*ihat(-1);
end;

shocks;
var e = std_a_val^2;
end;

steady;
stoch_simul(order=1, nograph, hp_filter = 1600, irf =100);