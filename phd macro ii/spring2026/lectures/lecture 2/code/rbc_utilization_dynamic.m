function [residual, g1, g2, g3] = rbc_utilization_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(11, 1);
lhs =y(5);
rhs =params(9)*y(1)+x(it_, 1);
residual(1)= lhs-rhs;
lhs =y(13);
rhs =params(5)/params(4)*y(15);
residual(2)= lhs-rhs;
lhs =y(14);
rhs =params(4)/params(3);
residual(3)= lhs-rhs;
lhs =y(12);
rhs =y(10)+params(7)*y(7);
residual(4)= lhs-rhs;
lhs =y(10);
rhs =(-params(2))*params(10)*y(17)-y(15)*params(3)*params(4)*params(2)+y(16);
residual(5)= lhs-rhs;
lhs =y(6);
rhs =y(10)*params(11)+params(12)*y(11);
residual(6)= lhs-rhs;
lhs =y(6);
rhs =y(5)+params(1)*y(9)+y(7)*(1-params(1));
residual(7)= lhs-rhs;
lhs =y(8);
rhs =(1-params(3))*y(2)-params(4)*y(4)+params(3)*y(3);
residual(8)= lhs-rhs;
lhs =y(13);
rhs =y(5)-(1-params(1))*(y(9)-y(7));
residual(9)= lhs-rhs;
lhs =y(12);
rhs =y(5)+params(1)*(y(9)-y(7));
residual(10)= lhs-rhs;
lhs =y(9);
rhs =y(15)+y(8);
residual(11)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(11, 18);

  %
  % Jacobian matrix
  %

  g1(1,1)=(-params(9));
  g1(1,5)=1;
  g1(1,18)=(-1);
  g1(2,13)=1;
  g1(2,15)=(-(params(5)/params(4)));
  g1(3,14)=1;
  g1(4,7)=(-params(7));
  g1(4,10)=(-1);
  g1(4,12)=1;
  g1(5,10)=1;
  g1(5,16)=(-1);
  g1(5,17)=(-((-params(2))*params(10)));
  g1(5,15)=params(3)*params(4)*params(2);
  g1(6,6)=1;
  g1(6,10)=(-params(11));
  g1(6,11)=(-params(12));
  g1(7,5)=(-1);
  g1(7,6)=1;
  g1(7,7)=(-(1-params(1)));
  g1(7,9)=(-params(1));
  g1(8,2)=(-(1-params(3)));
  g1(8,8)=1;
  g1(8,3)=(-params(3));
  g1(8,4)=params(4);
  g1(9,5)=(-1);
  g1(9,7)=(-(1-params(1)));
  g1(9,9)=1-params(1);
  g1(9,13)=1;
  g1(10,5)=(-1);
  g1(10,7)=params(1);
  g1(10,9)=(-params(1));
  g1(10,12)=1;
  g1(11,8)=(-1);
  g1(11,9)=1;
  g1(11,15)=(-1);

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],11,324);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],11,5832);
end
end
end
end
