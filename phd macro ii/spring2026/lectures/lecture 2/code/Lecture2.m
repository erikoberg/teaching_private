clear all 
clc
addpath('c:/Program Files/dynare/dynare4.5.1/matlab')

%%%%%%%%%%%%%%%%%%%%%
%%%%%Calibration%%%%%
%%%%%%%%%%%%%%%%%%%%%

%%%%%Data moments%%%%%
ls_ss = 2/3;
dep_factor_yearly_ss = 0.9;
dep_factor_ss = dep_factor_yearly_ss^(1/4);
gross_return_ss = (1+0.04+(1-dep_factor_yearly_ss))^(1/4)-1;
hours_worked_ss = 0.7;
Frish_elasticity = 1;
SR_std = 0.009;
SR_persistence = 0.974;

%%%%%Parameter values%%%%%
%Directly identified
std_a = SR_std;
rho_a = SR_persistence;

delta = 1 - dep_factor_ss;
alpha = 1 - ls_ss;
varphi = 1/Frish_elasticity;
beta = 1/(gross_return_ss + (1-delta));
sigma = 1;

%Implied moments
R_ss = 1/beta - (1-delta);
W_ss = (1-alpha)*(R_ss/alpha)^(-alpha/(1-alpha));
CY_ss = 1-delta*alpha/R_ss;
IY_ss = 1-CY_ss;

%Implied theta
theta = 1/(hours_worked_ss^(1+varphi))*(W_ss/(R_ss/alpha-delta)*(R_ss/alpha)^(1/(1-alpha)));

%different varphi
varphi_vec = [0.0001, 0.5, 1.0, 5.0];

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
for i = 1:4
    varphi = varphi_vec(i);
    save('parameters.mat')
    dynare rbc.mod;
    ahat(i,:) = ahat_e;
    yhat(i,:) = yhat_e;
    chat(i,:) = chat_e;
    ihat(i,:) = ihat_e;
    nhat(i,:) = nhat_e;
    i=i+1;
end
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Time Series Plots  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=100;

%Generate shock sequence
epsilon_vec = 100*std_a*randn(1,T);

%Generate time series of endogenous variables
ahat_sim = zeros(4,T);
yhat_sim = zeros(4,T);
ihat_sim = zeros(4,T);
nhat_sim = zeros(4,T);
khat_sim = zeros(4,T);
chat_sim = zeros(4,T);
what_sim = zeros(4,T);
rhat_sim = zeros(4,T);
for i=1:4
    for t=1:T
        for s=1:t
            if s<100
                ahat_sim(i,t) = ahat_sim(i,t) + epsilon_vec(t-(s-1))*ahat(i,s);
                yhat_sim(i,t) = yhat_sim(i,t) + epsilon_vec(t-(s-1))*yhat(i,s);
                ihat_sim(i,t) = ihat_sim(i,t) + epsilon_vec(t-(s-1))*ihat(i,s);
                nhat_sim(i,t) = nhat_sim(i,t) + epsilon_vec(t-(s-1))*nhat(i,s);
                chat_sim(i,t) = chat_sim(i,t) + epsilon_vec(t-(s-1))*chat(i,s);
            end
        end
    end
end

FigHandle = figure('Position', [0, 0, 800, 600]);

R=2;
C=1;

subplot(R,C,1)
plot(1:T, 100.*squeeze(yhat_sim(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_sim(2,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_sim(3,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_sim(4,1:T)), '-.', 'Linewidth', 2); hold on;
ylabel('Percent');
title('Output')
legend('Frish -> infty', 'Frish = 2', 'Frish = 1', 'Frish = 0.2')
grid on;
 
subplot(R,C,2)
plot(1:T, 100.*squeeze(nhat_sim(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_sim(2,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_sim(3,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_sim(4,1:T)), '-.', 'Linewidth', 2); hold on;
ylabel('Percent');
xlabel('Quarters');
title('Hours')
legend('Frish -> infty', 'Frish = 2', 'Frish = 1', 'Frish = 0.2')
grid on;
saveas(FigHandle,'../Figures/rbc_simulation_frish', 'pdf')


clear all 
clc
addpath('c:/Program Files/dynare/dynare4.5.1/matlab')

%%%%%%%%%%%%%%%%%%%%%
%%%%%Calibration%%%%%
%%%%%%%%%%%%%%%%%%%%%

%%%%%Data moments%%%%%
ls_ss = 2/3;
dep_factor_yearly_ss = 0.9;
dep_factor_ss = dep_factor_yearly_ss^(1/4);
gross_return_ss = (1+0.04+(1-dep_factor_yearly_ss))^(1/4)-1;
hours_worked_ss = 0.7;
Frish_elasticity = 1;
SR_std = 0.009;
SR_persistence = 0.974;

%%%%%Parameter values%%%%%
%Directly identified
std_a = SR_std;
rho_a = SR_persistence;

delta = 1 - dep_factor_ss;
alpha = 1 - ls_ss;
varphi = 1/Frish_elasticity;
beta = 1/(gross_return_ss + (1-delta));
sigma = 1;

%Implied moments
R_ss = 1/beta - (1-delta);
W_ss = (1-alpha)*(R_ss/alpha)^(-alpha/(1-alpha));
CY_ss = 1-delta*alpha/R_ss;
IY_ss = 1-CY_ss;

%Implied theta
theta = 1/(hours_worked_ss^(1+varphi))*(W_ss/(R_ss/alpha-delta)*(R_ss/alpha)^(1/(1-alpha)));

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
dynare rbc.mod;
ahat(1,:) = ahat_e;
yhat(1,:) = yhat_e;
chat(1,:) = chat_e;
ihat(1,:) = ihat_e;
nhat(1,:) = nhat_e;

dynare rbc_ghh.mod;
ahat(2,:) = ahat_e;
yhat(2,:) = yhat_e;
chat(2,:) = chat_e;
ihat(2,:) = ihat_e;
nhat(2,:) = nhat_e;

save('result.mat')
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Time Series Plots  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result.mat')

T=100;

%Generate shock sequence
epsilon_vec = 100*std_a*randn(1,T);

%Generate time series of endogenous variables
ahat_sim = zeros(2,T);
yhat_sim = zeros(2,T);
ihat_sim = zeros(2,T);
nhat_sim = zeros(2,T);
khat_sim = zeros(2,T);
chat_sim = zeros(2,T);
what_sim = zeros(2,T);
rhat_sim = zeros(2,T);
for i=1:2
    for t=1:T
        for s=1:t
            if s<100
                ahat_sim(i,t) = ahat_sim(i,t) + epsilon_vec(t-(s-1))*ahat(i,s);
                yhat_sim(i,t) = yhat_sim(i,t) + epsilon_vec(t-(s-1))*yhat(i,s);
                ihat_sim(i,t) = ihat_sim(i,t) + epsilon_vec(t-(s-1))*ihat(i,s);
                nhat_sim(i,t) = nhat_sim(i,t) + epsilon_vec(t-(s-1))*nhat(i,s);
                chat_sim(i,t) = chat_sim(i,t) + epsilon_vec(t-(s-1))*chat(i,s);
            end
        end
    end
end


FigHandle = figure('Position', [0, 0, 800, 600]);

R=2;
C=1;

subplot(R,C,1)
plot(1:T, 100.*squeeze(yhat_sim(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_sim(2,1:T)), '--', 'Linewidth', 2); hold on;
ylabel('Percent');
title('Output')
legend('Baseline', 'GHH')
grid on;
 
subplot(R,C,2)
plot(1:T, 100.*squeeze(nhat_sim(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_sim(2,1:T)), '--', 'Linewidth', 2); hold on;
ylabel('Percent');
xlabel('Quarters');
title('Hours')
legend('Baseline', 'GHH')
grid on;
saveas(FigHandle,'../Figures/rbc_simulation_ghh', 'pdf')