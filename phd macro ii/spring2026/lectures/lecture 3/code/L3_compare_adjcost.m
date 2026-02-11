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

%Implied moments
R_ss = 1/beta - (1-delta);
W_ss = (1-alpha)*(R_ss/alpha)^(-alpha/(1-alpha));
CY_ss = 1-delta*alpha/R_ss;
IY_ss = 1-CY_ss;
N_ss = hours_worked_ss;
K_ss = (R_ss/alpha)^(-1/(1-alpha))*N_ss;
KN_ss = K_ss/N_ss;
Y_ss = R_ss/alpha*K_ss;


%Implied parameters
theta = 1/(hours_worked_ss^(1+varphi))*(W_ss/(R_ss/alpha-delta)*(R_ss/alpha)^(1/(1-alpha)));

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
i=1;
for phi = [0, 2, 5, 10]
    save('parameters.mat')
    dynare rbc_adjcost.mod;
    ahat_ac(i,:) = ahat_e;
    yhat_ac(i,:) = yhat_e;
    chat_ac(i,:) = chat_e;
    ihat_ac(i,:) = ihat_e;
    khat_ac(i,:) = khat_e;
    nhat_ac(i,:) = nhat_e;
    what_ac(i,:) = what_e;
    rhat_ac(i,:) = rhat_e;
    Rhat_ac(i,:) = Rhat_e;
    qhat_ac(i,:) = qhat_e;
    save('results_adjcost.mat')
    i=i+1;
end
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  IRF Plots  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('results_adjcost.mat')
FigHandle = figure('Position', [0, 0, 800, 900]);

R=4;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*squeeze(ahat_ac(1,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*squeeze(yhat_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
legend('phi = 0','phi = 2','phi = 5','phi = 10')
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*squeeze(chat_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')

subplot(R,C,4)
plot(1:T, 100.*squeeze(ihat_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')

subplot(R,C,5)
plot(1:T, 100.*squeeze(qhat_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}q'}); grid on
ylabel('Percent')

subplot(R,C,6)
plot(1:T, 100.*squeeze(nhat_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours'}); grid on
ylabel('Percent')


subplot(R,C,7)
plot(1:T, 100.*squeeze(what_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')


subplot(R,C,8)
plot(1:T, 100.*squeeze(Rhat_ac(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_ac(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_ac(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
saveas(FigHandle,'../Figures/rbc_irf_adjcost', 'pdf')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Model with collateral constraint%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clc

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
phi =  2;
xi = 0.5*delta;

%Implied moments
Q_ss = beta;
q_ss = delta/xi;
mu_ss = q_ss-1;
R_ss = delta/xi*(1/beta - (1-xi));
W_ss = (1-alpha)*(R_ss/alpha)^(-alpha/(1-alpha));
CY_ss = 1-delta*alpha/R_ss;
IY_ss = 1-CY_ss;
N_ss = hours_worked_ss;
K_ss = (R_ss/alpha)^(-1/(1-alpha))*N_ss;
KN_ss = K_ss/N_ss;
Y_ss = R_ss/alpha*K_ss;

%Implied parameters
theta = 1/(hours_worked_ss^(1+varphi))*(W_ss/(R_ss/alpha-delta)*(R_ss/alpha)^(1/(1-alpha)));

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
i=1;
for phi = [0, 2, 5, 10]
    save('parameters.mat')
    dynare rbc_adjcost_collateralconstraint.mod;
    ahat_cc(i,:) = ahat_e;
    yhat_cc(i,:) = yhat_e;
    chat_cc(i,:) = chat_e;
    ihat_cc(i,:) = ihat_e;
    khat_cc(i,:) = khat_e;
    nhat_cc(i,:) = nhat_e;
    what_cc(i,:) = what_e;
    rhat_cc(i,:) = rhat_e;
    Rhat_cc(i,:) = Rhat_e;
    qhat_cc(i,:) = qhat_e;
    save('results_financialconstraint.mat')
    i=i+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  IRF Plots  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('results_adjcost.mat')
FigHandle = figure('Position', [0, 0, 800, 900]);


R=4;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*squeeze(ahat_cc(2,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*squeeze(yhat_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
legend('xi = 0.5 x delta','xi=infty')
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*squeeze(chat_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')

subplot(R,C,4)
plot(1:T, 100.*squeeze(ihat_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')

subplot(R,C,5)
plot(1:T, 100.*squeeze(qhat_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}q'}); grid on
ylabel('Percent')

subplot(R,C,6)
plot(1:T, 100.*squeeze(nhat_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours'}); grid on
ylabel('Percent')


subplot(R,C,7)
plot(1:T, 100.*squeeze(what_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')


subplot(R,C,8)
plot(1:T, 100.*squeeze(Rhat_cc(2,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_ac(2,1:T)), '-.', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
saveas(FigHandle,'../Figures/rbc_irf_finconstraint', 'pdf')







FigHandle = figure('Position', [0, 0, 800, 900]);

R=4;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*squeeze(ahat_ac(1,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*squeeze(yhat_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
legend('phi = 0','phi = 2','phi = 5','phi = 10')
title({'\fontsize{12}Output'}); grid on
legend('phi = 0','phi = 2','phi = 5','phi = 10')
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*squeeze(chat_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')

subplot(R,C,4)
plot(1:T, 100.*squeeze(ihat_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')

subplot(R,C,5)
plot(1:T, 100.*squeeze(qhat_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(qhat_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}q'}); grid on
ylabel('Percent')

subplot(R,C,6)
plot(1:T, 100.*squeeze(nhat_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours'}); grid on
ylabel('Percent')


subplot(R,C,7)
plot(1:T, 100.*squeeze(what_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')


subplot(R,C,8)
plot(1:T, 100.*squeeze(Rhat_cc(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_cc(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_cc(3,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(Rhat_cc(4,1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
saveas(FigHandle,'../Figures/rbc_irf_financialconstraint_compare_adjcost', 'pdf')