function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = nk_fullsystem.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(12, 18);
g1(1,1)=(-params(7));
g1(1,12)=1;
g1(1,18)=(-1);
g1(2,16)=1;
g1(2,10)=(-1);
g1(2,11)=1;
g1(3,4)=1;
g1(3,11)=(-((-1)/params(3)));
g1(3,12)=(-1);
g1(3,2)=(-1);
g1(4,4)=(-params(3));
g1(4,5)=(-params(4));
g1(4,7)=1;
g1(5,6)=(-params(1));
g1(5,9)=1;
g1(5,16)=(-params(2));
g1(6,6)=1;
g1(6,7)=(-1);
g1(7,4)=1;
g1(7,5)=(-params(6));
g1(7,7)=(-params(6));
g1(7,8)=(-(1-params(6)));
g1(8,3)=(-1);
g1(8,4)=1;
g1(9,3)=1;
g1(9,5)=(-1);
g1(10,9)=(-params(5));
g1(10,10)=1;
g1(11,13)=1;
g1(11,17)=(-1);
g1(12,15)=(-1);
g1(12,14)=1;

end
