clear all 
clc
addpath('c:/dynare/4.6.4/matlab')

%%%%%%%%%%%%%%%%%%%%%
%%%%%Calibration%%%%%
%%%%%%%%%%%%%%%%%%%%%

%%%%%Parameter values%%%%%
beta = 0.99;
varphi = 1;
theta = 2/3;
epsilon = 6;
phi_pi = 1.5;
rho_nu = 0.5;
std_nu = 1;
rho_a = 0.9;
std_a = 1;

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
FigHandle = figure('Position', [0, 0, 800, 600]);

R=2;
C=2;
T=10;

subplot(R,C,1)
plot(1:T, squeeze(nu_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 4*squeeze(ihat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Ann. percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, squeeze(yhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, 4*squeeze(pi_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Ann. Percent')
xlabel('Quarters')
%axis([1 T 0 1])

saveas(FigHandle,'../figures/nk_monshock_4variables', 'pdf')
% 


FigHandle = figure('Position', [0, 0, 800, 600]);

R=2;
C=2;
T=20;

subplot(R,C,1)
plot(1:T, squeeze(a_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 4*squeeze(ihat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Ann. percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, squeeze(yhat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, 4*squeeze(pi_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Ann. Percent')
xlabel('Quarters')
%axis([1 T 0 1])

saveas(FigHandle,'../figures/nk_tfpshock_4variables', 'pdf')
% 

FigHandle = figure('Position', [0, 0, 900, 600]);

R=3;
C=3;
T=10;

subplot(R,C,1)
plot(1:T, squeeze(nu_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 4*squeeze(ihat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Ann. percent')
axis([1 T -0.5 0.5])

subplot(R,C,3)
plot(1:T, 4*squeeze(rhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real Interest rate'}); grid on
ylabel('Ann. percent')
axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, squeeze(yhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
axis([1 T -1 0])

subplot(R,C,5)
plot(1:T, squeeze(chat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
axis([1 T -1 0])

subplot(R,C,6)
plot(1:T, squeeze(nhat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
axis([1 T -1 0])

subplot(R,C,7)
plot(1:T, squeeze(what_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T -2 0])

subplot(R,C,8)
plot(1:T, squeeze(mchat_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real marginal cost'}); grid on
ylabel('Percent')
xlabel('Quarters')
axis([1 T -2 0])

subplot(R,C,9)
plot(1:T, 4*squeeze(pi_e_nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Ann. Percent')
xlabel('Quarters')
axis([1 T -5 0])

saveas(FigHandle,'../figures/nk_monshock_9variables', 'pdf')



FigHandle = figure('Position', [0, 0, 900, 600]);

R=3;
C=3;
T=20;

subplot(R,C,1)
plot(1:T, squeeze(a_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 4*squeeze(ihat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Ann. percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 4*squeeze(rhat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real Interest rate'}); grid on
ylabel('Ann. percent')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, squeeze(yhat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,5)
plot(1:T, squeeze(chat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,6)
plot(1:T, squeeze(nhat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,7)
plot(1:T, squeeze(what_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,8)
plot(1:T, squeeze(mchat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real marginal cost'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,9)
plot(1:T, 4*squeeze(pi_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Ann. Percent')
xlabel('Quarters')
%axis([1 T 0 1])

saveas(FigHandle,'../figures/nk_tfpshock_9variables', 'pdf')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation of gaps%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dynare nk_gaps.mod;
FigHandle = figure('Position', [0, 0, 800, 600]);

R=2;
C=2;
T=20;

subplot(R,C,1)
plot(1:T, squeeze(a_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 4*squeeze(ihat_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Ann. percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, squeeze(ytilde_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output gap'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, 4*squeeze(pi_e_a(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Ann. Percent')
xlabel('Quarters')
%axis([1 T 0 1])

saveas(FigHandle,'../figures/nk_tfpshock_gaps_4variables', 'pdf')
% 


