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
ies = 1;
SR_std = 0.009;
SR_persistence = 0;

%%%%%Parameter values%%%%%
%Directly identified
std_a = SR_std;
rho_a = SR_persistence;

delta = 1 - dep_factor_ss;
alpha = 1 - ls_ss;
varphi = 1/Frish_elasticity;
sigma = 1/ies;
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
i=1;
for sigma = [1, 3, 5]
    save('parameters.mat')
    dynare rbc.mod;
    ahat(i,:) = ahat_e;
    yhat(i,:) = yhat_e;
    chat(i,:) = chat_e;
    ihat(i,:) = ihat_e;
    khat(i,:) = khat_e;
    nhat(i,:) = nhat_e;
    what(i,:) = what_e;
    rhat(i,:) = rhat_e;
    save('result.mat')
    i=i+1;
end
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Time Series Plots  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result.mat')

T=4*50;

%Generate shock sequence
epsilon_vec = 100*std_a*randn(1,T);

%Generate time series of endogenous variables
ahat_sim = zeros(3,T);
yhat_sim = zeros(3,T);
ihat_sim = zeros(3,T);
nhat_sim = zeros(3,T);
khat_sim = zeros(3,T);
chat_sim = zeros(3,T);
what_sim = zeros(3,T);
rhat_sim = zeros(3,T);
for i=1:3
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
ylabel('Percent');
title('Output')
legend('sigma = 1', 'sigma = 3', 'sigma = 5')
grid on;
 
subplot(R,C,2)
plot(1:T, 100.*squeeze(nhat_sim(1,1:T)), ':', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_sim(2,1:T)), '--', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat_sim(3,1:T)), '-', 'Linewidth', 2); hold on;
ylabel('Percent');
xlabel('Quarters');
title('Hours')
legend('sigma = 1', 'sigma = 3', 'sigma = 5')
grid on;
saveas(FigHandle,'./rbc_simulation_ies', 'pdf')




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
plot(1:T, 100.*squeeze(yhat(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(yhat(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Output'}); grid on
legend('sigma = 1', 'sigma = 3', 'sigma = 5')
ylabel('Percent')
%axis([1 T 0 1])

subplot(R,C,3)
plot(1:T, 100.*squeeze(chat(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(chat(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Consumption'}); grid on
ylabel('Percent')

subplot(R,C,4)
plot(1:T, 100.*squeeze(ihat(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(ihat(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Investment'}); grid on
ylabel('Percent')

subplot(R,C,5)
plot(1:T, 100.*squeeze(khat(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(khat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(khat(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Capital'}); grid on
ylabel('Percent')

subplot(R,C,6)
plot(1:T, 100.*squeeze(nhat(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(nhat(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Hours'}); grid on
ylabel('Percent')


subplot(R,C,7)
plot(1:T, 100.*squeeze(what(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(what(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real wage'}); grid on
ylabel('Percent')
xlabel('Quarters')


subplot(R,C,8)
plot(1:T, 100.*squeeze(rhat(1,1:T)), '-', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(rhat(2,1:T)), '-.', 'Linewidth', 2); hold on;
plot(1:T, 100.*squeeze(rhat(3,1:T)), '--', 'Linewidth', 2); hold on;
title({'\fontsize{12}Real return on capital'}); grid on
ylabel('Percent')
xlabel('Quarters')
saveas(FigHandle,'./rbc_irf_ies_blip', 'pdf')