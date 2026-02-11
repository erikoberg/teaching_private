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
g1 = zeros(13, 21);
g1(1,1)=(-params(6));
g1(1,13)=1;
g1(1,20)=(-1);
g1(2,2)=(-params(8));
g1(2,14)=1;
g1(2,21)=(-1);
g1(3,18)=1;
g1(3,11)=(-1);
g1(3,12)=1;
g1(4,5)=1;
g1(4,12)=1;
g1(4,3)=(-1);
g1(5,5)=(-1);
g1(5,6)=(-params(3));
g1(5,8)=1;
g1(6,7)=(-params(1));
g1(6,10)=1;
g1(6,18)=(-params(2));
g1(7,7)=1;
g1(7,8)=(-1);
g1(7,14)=1;
g1(8,5)=1;
g1(8,6)=(-params(5));
g1(8,8)=(-params(5));
g1(8,9)=(-(1-params(5)));
g1(9,4)=(-1);
g1(9,5)=1;
g1(10,4)=1;
g1(10,6)=(-1);
g1(10,14)=(-1);
g1(11,10)=(-params(4));
g1(11,11)=1;
g1(11,13)=(-1);
g1(12,15)=1;
g1(12,19)=(-1);
g1(13,17)=(-1);
g1(13,16)=1;

end
