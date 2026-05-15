clear all 
clc
addpath('c:/dynare/4.6.1/matlab')

%%%%%%%%%%%%%%%%%%%%%
%%%%%Calibration%%%%%
%%%%%%%%%%%%%%%%%%%%%

%%%%%Parameter values%%%%%
beta = 0.99;
varphi = 1;
theta = 2/3;
sigma = 1;
epsilon = 6;
phi_pi = 1.5;
rho_nu = 0.5;
std_nu = 1;

%Implied parameters
lambda = (1-theta)*(1-beta*theta)/theta;
kappa = (1+varphi)*lambda;
Markup = epsilon/(epsilon-1);
LS = 1/Markup;

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
dynare nk_fullsystem.mod;
save('result.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  IRF Plots  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result.mat')
FigHandle = figure('Position', [0, 0, 900, 600]);

R=3;
C=3;
T=10;

subplot(R,C,1)
plot(1:T, squeeze(nu_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
axis([1 T 0 2])

subplot(R,C,2)
plot(1:T, squeeze(ihat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Percent')
axis([1 T 0 2])

subplot(R,C,3)
plot(1:T, squeeze(rhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real Interest rate'}); grid on
ylabel('Percent')
axis([1 T 0 2])

subplot(R,C,4)
plot(1:T, squeeze(yhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,5)
plot(1:T, squeeze(chat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,6)
plot(1:T, squeeze(nhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,7)
plot(1:T, squeeze(what_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T 0 2])

subplot(R,C,8)
plot(1:T, squeeze(mchat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real marginal cost'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T 0 2])

subplot(R,C,9)
plot(1:T, squeeze(pi_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T 0 1])

saveas(FigHandle,'../figures/nk_cpshock_9variables', 'pdf')


beta = 0.99;
varphi = 1;
theta = 0.01;
sigma = 1;
epsilon = 6;
phi_pi = 1.5;
rho_nu = 0.5;
std_nu = 1;

%Implied parameters
lambda = (1-theta)*(1-beta*theta)/theta;
kappa = (1+varphi)*lambda;
Markup = epsilon/(epsilon-1);
LS = 1/Markup;

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
dynare nk_fullsystem.mod;
save('result.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  IRF Plots  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result.mat')
FigHandle = figure('Position', [0, 0, 900, 600]);

R=3;
C=3;
T=10;

subplot(R,C,1)
plot(1:T, squeeze(nu_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
axis([1 T 0 2])

subplot(R,C,2)
plot(1:T, squeeze(ihat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Percent')
axis([1 T 0 2])

subplot(R,C,3)
plot(1:T, squeeze(rhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real Interest rate'}); grid on
ylabel('Percent')
axis([1 T 0 2])

subplot(R,C,4)
plot(1:T, squeeze(yhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,5)
plot(1:T, squeeze(chat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,6)
plot(1:T, squeeze(nhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,7)
plot(1:T, squeeze(what_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T 0 2])

subplot(R,C,8)
plot(1:T, squeeze(mchat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real marginal cost'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T 0 2])

subplot(R,C,9)
plot(1:T, squeeze(pi_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T 0 1])

saveas(FigHandle,'../figures/nk_cpshock_flexprice_9variables', 'pdf')