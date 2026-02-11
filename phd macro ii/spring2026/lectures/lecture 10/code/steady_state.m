%Shimer calibration
sigma=0.1;
r=0.012;
y=1;
b=0.4;
A=1.34;
alpha = 0.72;
eta = 1-alpha;
gamma = alpha;
c = 0.2;

theta_low=0.0001;
theta_high=100;
theta=(theta_high+theta_low)/2;

while abs(theta_high-theta_low)>0.001
   RHS=c*((r+sigma)*A*theta^alpha+gamma*A*theta);
   LHS = (1-gamma)*(y-b);
   
   if RHS>LHS
       theta_high=theta;
   else
       theta_low=theta;
   end
   
   theta=(theta_high+theta_low)/2;
end

elasticity = y/(y-b)*(r+sigma+alpha*A*theta^(1-alpha))/((r+sigma)*(1-eta)+alpha*A*theta^(1-alpha)) 



%H&M calibration
sigma=0.1;
r=0.012;
y=1;
b=0.95;
A=1.34;
alpha = 0.72;
eta = 1-alpha;
gamma = 0.05;
c = 0.2;

theta_low=0.0001;
theta_high=100;
theta=(theta_high+theta_low)/2;

while abs(theta_high-theta_low)>0.001
   RHS=c*((r+sigma)*A*theta^alpha+gamma*A*theta);
   LHS = (1-gamma)*(y-b);
   
   if RHS>LHS
       theta_high=theta;
   else
       theta_low=theta;
   end
   
   theta=(theta_high+theta_low)/2;
end

elasticity = y/(y-b)*(r+sigma+alpha*A*theta^(1-alpha))/((r+sigma)*(1-eta)+alpha*A*theta^(1-alpha)) 