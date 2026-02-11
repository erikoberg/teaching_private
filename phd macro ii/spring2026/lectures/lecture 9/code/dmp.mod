var j z w h f h q m v u n z;
parameters beta sigma c phi lambda a rho b; 
varexo e;

load parameters.mat

beta = beta_val;
sigma = sigma_val; 
c = c_val;
b = b_val;
phi = phi_val;
lambda = lambda_val;
a = a_val;
rho = rho_val;

model;
j=z-w+beta*(1-sigma)*j(+1);
h=w-b+beta*((1-sigma)-f)*h(+1);
c=q*beta*j(+1);
phi*j=(1-phi)*h;
m=a*v^(1-lambda)*u^lambda;
f=m/u;
q=m/v;
n=(1-sigma)*n(-1)+m(-1);
u=1-n;
log(z) = rho*log(z(-1)) + log(e);
end;

shocks;
var e = 0.01^2;
end;

steady;
%stoch_simul(order=1);

