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
SR_persistence = 0.8;

%%%%%Parameter values%%%%%
%Directly identified
std_a = SR_std;
rho_a = SR_persistence;

delta0 = 1 - dep_factor_ss;
alpha = 1 - ls_ss;
varphi = 1/Frish_elasticity;
beta = 1/(gross_return_ss + (1-delta0));

%Implied moments
R_ss = 1/beta - (1-delta0);
W_ss = (1-alpha)*(R_ss/alpha)^(-alpha/(1-alpha));
CY_ss = 1-delta0*alpha/R_ss;
IY_ss = 1-CY_ss;

%Implied parameters
theta = 1/(hours_worked_ss^(1+varphi))*(W_ss/(R_ss/alpha-delta0)*(R_ss/alpha)^(1/(1-alpha)));
eta1 = R_ss;
eta2 = 1;

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
i=1;
for eta2 = [0.01, 0.1, 1, 10]
    save('parameters.mat')
    dynare rbc_utilization.mod;
    ahat(i,:) = ahat_e;
    yhat(i,:) = yhat_e;
    chat(i,:) = chat_e;
    ihat(i,:) = ihat_e;
    khat(i,:) = khat_e;
    nhat(i,:) = nhat_e;
    uhat(i,:) = uhat_e;
    what(i,:) = what_e;
    rhat(i,:) = rhat_e;
    save('result.mat')
    i=i+1;
end
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  IRF Plots  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result.mat')
FigHandle = figure('Position', [0, 0, 800, 900]);

R=4;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*squeeze(ahat(1,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*squeeze(yhat(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
legend('eta2 = 0.01','eta2 = 0.1','eta2 = 1','eta2 = 10')
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*squeeze(chat(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')

subplot(R,C,4)
plot(1:T, 100.*squeeze(ihat(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')

subplot(R,C,5)
plot(1:T, 100.*squeeze(uhat(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(uhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(uhat(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(uhat(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Utilization'}); grid on
ylabel('Percent')

subplot(R,C,6)
plot(1:T, 100.*squeeze(nhat(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours'}); grid on
ylabel('Percent')


subplot(R,C,7)
plot(1:T, 100.*squeeze(what(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')


subplot(R,C,8)
plot(1:T, 100.*squeeze(rhat(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(rhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(rhat(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(rhat(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
saveas(FigHandle,'../Figures/rbc_irf_utilization', 'pdf')