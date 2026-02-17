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
SR_persistence = 0.979;

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

%Implied theta
theta = 1/(hours_worked_ss^(1+varphi))*(W_ss/(R_ss/alpha-delta)*(R_ss/alpha)^(1/(1-alpha)));

%Save
save('parameters.mat')

%%%%%%%%%%%%%%%%%%%%
%%%%%Simulation%%%%%
%%%%%%%%%%%%%%%%%%%%
dynare rbc.mod;
save('result_standardshock.mat')
%Blip shock
rho_a = 0;
save('parameters.mat')
dynare rbc.mod;
save('result_blipshock.mat')
%Blip shock no capital
alpha = 0;
W_ss = (1-alpha)*(R_ss/alpha)^(-alpha/(1-alpha));
CY_ss = 1-delta*alpha/R_ss;
IY_ss = 1-CY_ss;
save('parameters.mat')
dynare rbc.mod;
save('result_blipshock_nocapital.mat')
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  IRF Plots  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result_standardshock.mat')
FigHandle = figure('Position', [0, 0, 800, 900]);

R=4;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*oo_.irfs.ahat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*oo_.irfs.yhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*oo_.irfs.chat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, 100.*oo_.irfs.ihat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,5)
plot(1:T, 100.*oo_.irfs.khat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Capital stock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])


subplot(R,C,6)
plot(1:T, 100.*oo_.irfs.nhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,7)
plot(1:T, 100.*oo_.irfs.what_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wages'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,8)
plot(1:T, 100.*oo_.irfs.rhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])
saveas(FigHandle,'../Figures/rbc_irf_standardshock', 'pdf')



%%%%%Blip shock
load('result_blipshock.mat')
FigHandle = figure('Position', [0, 0, 800, 900]);

R=4;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*oo_.irfs.ahat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*oo_.irfs.yhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*oo_.irfs.chat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, 100.*oo_.irfs.ihat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,5)
plot(1:T, 100.*oo_.irfs.khat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Capital stock'}); grid on
ylabel('Percent')
%axis([1 T 0 1])


subplot(R,C,6)
plot(1:T, 100.*oo_.irfs.nhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,7)
plot(1:T, 100.*oo_.irfs.what_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wages'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])

subplot(R,C,8)
plot(1:T, 100.*oo_.irfs.rhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])
saveas(FigHandle,'../Figures/rbc_irf_blipshock', 'pdf')



%%%%%Blip shock no capital
load('result_blipshock_nocapital.mat')
FigHandle = figure('Position', [0, 0, 800, 900]);

R=3;
C=2;
T=40;

subplot(R,C,1)
plot(1:T, 100.*oo_.irfs.ahat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}TFP'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,2)
plot(1:T, 100.*oo_.irfs.yhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*oo_.irfs.chat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,4)
plot(1:T, 100.*oo_.irfs.nhat_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours worked'}); grid on
ylabel('Percent')
axis([1 T 0 1])

subplot(R,C,5)
plot(1:T, 100.*oo_.irfs.what_e(1:T), '-', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wages'}); grid on
ylabel('Percent')
xlabel('Quarters')
%axis([1 T 0 1])
saveas(FigHandle,'../Figures/rbc_irf_blipshock_nocapital', 'pdf')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Time Series Plots  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result_standardshock.mat')

T=4*50;

%Generate shock sequence
epsilon_vec = 100*std_a*randn(1,T);

%Generate time series of endogenous variables
ahat_sim = zeros(1,T);
yhat_sim = zeros(1,T);
ihat_sim = zeros(1,T);
nhat_sim = zeros(1,T);
khat_sim = zeros(1,T);
chat_sim = zeros(1,T);
what_sim = zeros(1,T);
rhat_sim = zeros(1,T);
for t=1:T
    for s=1:t
        if s<100
            ahat_sim(t) = ahat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.ahat_e(s);
            yhat_sim(t) = yhat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.yhat_e(s);
            ihat_sim(t) = ihat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.ihat_e(s);
            nhat_sim(t) = nhat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.nhat_e(s);
            khat_sim(t) = khat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.khat_e(s);
            chat_sim(t) = chat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.chat_e(s);
            what_sim(t) = what_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.what_e(s);
            rhat_sim(t) = rhat_sim(t) + epsilon_vec(t-(s-1))*oo_.irfs.rhat_e(s);
        end
    end
end

FigHandle = figure('Position', [0, 0, 800, 800]);

R=3;
C=1;

subplot(R,C,1)
plot(1:T, 100.*yhat_sim(1:T), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*ahat_sim(1:T), '--', 'Linewidth', 2); hold on;
ylabel('Percent');
legend('Output','TFP')
grid on;

subplot(R,C,2)
plot(1:T, 100.*yhat_sim(1:T), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*ihat_sim(1:T), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*chat_sim(1:T), '--', 'Linewidth', 2); hold on;
ylabel('Percent');
legend('Output','Investment','Consumption')
grid on;

subplot(R,C,3)
plot(1:T, 100.*yhat_sim(1:T), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*khat_sim(1:T), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*nhat_sim(1:T), '--', 'Linewidth', 2); hold on;
ylabel('Percent');
xlabel('Quarters');
legend('Output','Capital','Hours')
grid on;
saveas(FigHandle,'../Figures/rbc_simulation', 'pdf')
