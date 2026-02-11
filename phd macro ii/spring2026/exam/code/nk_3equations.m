clear all 
clc
addpath('c:/Program Files/dynare/dynare4.5.1/matlab')

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
save('parameters.mat')
dynare nk_3equation.mod;
yhat = yhat_e;
pi = pi_e;
ihat = ihat_e;
nu = nu_e;
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
plot(1:T, squeeze(nu(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Shock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, squeeze(ihat(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Nominal Interest rate'}); grid on
ylabel('Ann. percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, squeeze(yhat(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, squeeze(pi(1:T)), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Inflation'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

saveas(FigHandle,'../figures/np_3equations', 'pdf')
% 
