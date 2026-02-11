function [residual, g1, g2, g3] = dmp_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(10, 1);
T46 = params(6)*y(11)^(1-params(5));
T48 = y(12)^params(5);
lhs =y(4);
rhs =y(5)-y(6)+params(1)*(1-params(2))*y(14);
residual(1)= lhs-rhs;
lhs =y(7);
rhs =y(6)-params(8)+params(1)*(1-params(2)-y(8))*y(15);
residual(2)= lhs-rhs;
lhs =params(3);
rhs =y(14)*params(1)*y(9);
residual(3)= lhs-rhs;
lhs =y(4)*params(4);
rhs =y(7)*(1-params(4));
residual(4)= lhs-rhs;
lhs =y(10);
rhs =T46*T48;
residual(5)= lhs-rhs;
lhs =y(8);
rhs =y(10)/y(12);
residual(6)= lhs-rhs;
lhs =y(9);
rhs =y(10)/y(11);
residual(7)= lhs-rhs;
lhs =y(13);
rhs =(1-params(2))*y(3)+y(2);
residual(8)= lhs-rhs;
lhs =y(12);
rhs =1-y(13);
residual(9)= lhs-rhs;
lhs =log(y(5));
rhs =params(7)*log(y(1))+log(x(it_, 1));
residual(10)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(10, 16);

  %
  % Jacobian matrix
  %

T90 = params(6)*getPowerDeriv(y(11),1-params(5),1);
T97 = getPowerDeriv(y(12),params(5),1);
  g1(1,4)=1;
  g1(1,14)=(-(params(1)*(1-params(2))));
  g1(1,5)=(-1);
  g1(1,6)=1;
  g1(2,6)=(-1);
  g1(2,7)=1;
  g1(2,15)=(-(params(1)*(1-params(2)-y(8))));
  g1(2,8)=(-(y(15)*(-params(1))));
  g1(3,14)=(-(params(1)*y(9)));
  g1(3,9)=(-(params(1)*y(14)));
  g1(4,4)=params(4);
  g1(4,7)=(-(1-params(4)));
  g1(5,10)=1;
  g1(5,11)=(-(T48*T90));
  g1(5,12)=(-(T46*T97));
  g1(6,8)=1;
  g1(6,10)=(-(1/y(12)));
  g1(6,12)=(-((-y(10))/(y(12)*y(12))));
  g1(7,9)=1;
  g1(7,10)=(-(1/y(11)));
  g1(7,11)=(-((-y(10))/(y(11)*y(11))));
  g1(8,2)=(-1);
  g1(8,3)=(-(1-params(2)));
  g1(8,13)=1;
  g1(9,12)=1;
  g1(9,13)=1;
  g1(10,1)=(-(params(7)*1/y(1)));
  g1(10,5)=1/y(5);
  g1(10,16)=(-(1/x(it_, 1)));

if nargout >= 3,
  %
  % Hessian matrix
  %

  v2 = zeros(17,3);
  v2(1,1)=2;
  v2(1,2)=127;
  v2(1,3)=params(1);
  v2(2,1)=2;
  v2(2,2)=232;
  v2(2,3)=  v2(1,3);
  v2(3,1)=3;
  v2(3,2)=142;
  v2(3,3)=(-params(1));
  v2(4,1)=3;
  v2(4,2)=217;
  v2(4,3)=  v2(3,3);
  v2(5,1)=5;
  v2(5,2)=171;
  v2(5,3)=(-(T48*params(6)*getPowerDeriv(y(11),1-params(5),2)));
  v2(6,1)=5;
  v2(6,2)=187;
  v2(6,3)=(-(T90*T97));
  v2(7,1)=5;
  v2(7,2)=172;
  v2(7,3)=  v2(6,3);
  v2(8,1)=5;
  v2(8,2)=188;
  v2(8,3)=(-(T46*getPowerDeriv(y(12),params(5),2)));
  v2(9,1)=6;
  v2(9,2)=186;
  v2(9,3)=(-((-1)/(y(12)*y(12))));
  v2(10,1)=6;
  v2(10,2)=156;
  v2(10,3)=  v2(9,3);
  v2(11,1)=6;
  v2(11,2)=188;
  v2(11,3)=(-((-((-y(10))*(y(12)+y(12))))/(y(12)*y(12)*y(12)*y(12))));
  v2(12,1)=7;
  v2(12,2)=170;
  v2(12,3)=(-((-1)/(y(11)*y(11))));
  v2(13,1)=7;
  v2(13,2)=155;
  v2(13,3)=  v2(12,3);
  v2(14,1)=7;
  v2(14,2)=171;
  v2(14,3)=(-((-((-y(10))*(y(11)+y(11))))/(y(11)*y(11)*y(11)*y(11))));
  v2(15,1)=10;
  v2(15,2)=1;
  v2(15,3)=(-(params(7)*(-1)/(y(1)*y(1))));
  v2(16,1)=10;
  v2(16,2)=69;
  v2(16,3)=(-1)/(y(5)*y(5));
  v2(17,1)=10;
  v2(17,2)=256;
  v2(17,3)=(-((-1)/(x(it_, 1)*x(it_, 1))));
  g2 = sparse(v2(:,1),v2(:,2),v2(:,3),10,256);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],10,4096);
end
end
end
end
