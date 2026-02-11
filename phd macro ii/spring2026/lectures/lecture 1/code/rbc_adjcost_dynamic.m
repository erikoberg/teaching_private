function [residual, g1, g2, g3] = rbc_adjcost_dynamic(y, x, params, steady_state, it_)
%
% Status : Computes dynamic model for Dynare
%
% Inputs :
%   y         [#dynamic variables by 1] double    vector of endogenous variables in the order stored
%                                                 in M_.lead_lag_incidence; see the Manual
%   x         [nperiods by M_.exo_nbr] double     matrix of exogenous variables (in declaration order)
%                                                 for all simulation periods
%   steady_state  [M_.endo_nbr by 1] double       vector of steady state values
%   params    [M_.param_nbr by 1] double          vector of parameter values in declaration order
%   it_       scalar double                       time period for exogenous variables for which to evaluate the model
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the dynamic model equations in order of 
%                                          declaration of the equations.
%                                          Dynare may prepend auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by #dynamic variables] double    Jacobian matrix of the dynamic model equations;
%                                                           rows: equations in order of declaration
%                                                           columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g2        [M_.endo_nbr by (#dynamic variables)^2] double   Hessian matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g3        [M_.endo_nbr by (#dynamic variables)^3] double   Third order derivative matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

%
% Model equations
%

residual = zeros(9, 1);
T39 = params(2)*params(6)*params(3)^2;
lhs =y(4);
rhs =params(8)*y(1)+x(it_, 1);
residual(1)= lhs-rhs;
lhs =y(10);
rhs =y(8)+params(5)*y(6);
residual(2)= lhs-rhs;
lhs =y(8)-y(12);
rhs =(-params(2))*params(9)*y(16)-params(2)*(1-params(3))*y(17)-T39*(y(15)-y(13))+y(14);
residual(3)= lhs-rhs;
lhs =y(12);
rhs =params(3)*params(6)*(y(9)-y(7));
residual(4)= lhs-rhs;
lhs =y(5);
rhs =y(8)*params(10)+y(9)*params(11);
residual(5)= lhs-rhs;
lhs =y(5);
rhs =y(4)+y(7)*params(1)+y(6)*(1-params(1));
residual(6)= lhs-rhs;
lhs =y(7);
rhs =(1-params(3))*y(2)+params(3)*y(3);
residual(7)= lhs-rhs;
lhs =y(11);
rhs =y(4)-(1-params(1))*(y(7)-y(6));
residual(8)= lhs-rhs;
lhs =y(10);
rhs =y(4)+params(1)*(y(7)-y(6));
residual(9)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(9, 18);

  %
  % Jacobian matrix
  %

  g1(1,1)=(-params(8));
  g1(1,4)=1;
  g1(1,18)=(-1);
  g1(2,6)=(-params(5));
  g1(2,8)=(-1);
  g1(2,10)=1;
  g1(3,13)=(-T39);
  g1(3,8)=1;
  g1(3,14)=(-1);
  g1(3,15)=T39;
  g1(3,16)=(-((-params(2))*params(9)));
  g1(3,12)=(-1);
  g1(3,17)=params(2)*(1-params(3));
  g1(4,7)=params(3)*params(6);
  g1(4,9)=(-(params(3)*params(6)));
  g1(4,12)=1;
  g1(5,5)=1;
  g1(5,8)=(-params(10));
  g1(5,9)=(-params(11));
  g1(6,4)=(-1);
  g1(6,5)=1;
  g1(6,6)=(-(1-params(1)));
  g1(6,7)=(-params(1));
  g1(7,2)=(-(1-params(3)));
  g1(7,7)=1;
  g1(7,3)=(-params(3));
  g1(8,4)=(-1);
  g1(8,6)=(-(1-params(1)));
  g1(8,7)=1-params(1);
  g1(8,11)=1;
  g1(9,4)=(-1);
  g1(9,6)=params(1);
  g1(9,7)=(-params(1));
  g1(9,10)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],9,324);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],9,5832);
end
end
end
end
