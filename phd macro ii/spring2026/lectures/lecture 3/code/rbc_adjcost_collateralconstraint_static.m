function [residual, g1, g2, g3] = rbc_adjcost_collateralconstraint_static(y, x, params)
%
% Status : Computes static model for Dynare
%
% Inputs : 
%   y         [M_.endo_nbr by 1] double    vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1] double     vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1] double   vector of parameter values in declaration order
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the static model equations 
%                                          in order of declaration of the equations.
%                                          Dynare may prepend or append auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by M_.endo_nbr] double    Jacobian matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%   g2        [M_.endo_nbr by (M_.endo_nbr)^2] double   Hessian matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%   g3        [M_.endo_nbr by (M_.endo_nbr)^3] double   Third derivatives matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

residual = zeros( 12, 1);

%
% Model equations
%

T47 = params(6)*params(3)^2/params(10);
lhs =y(1);
rhs =y(1)*params(9)+x(1);
residual(1)= lhs-rhs;
lhs =y(7);
rhs =y(5)+params(5)*y(3);
residual(2)= lhs-rhs;
lhs =y(8);
rhs =(-y(10));
residual(3)= lhs-rhs;
lhs =y(5);
rhs =y(5)-y(8);
residual(4)= lhs-rhs;
lhs =y(6);
rhs =y(11)+y(4);
residual(5)= lhs-rhs;
lhs =y(7);
rhs =y(1)+params(1)*(y(4)-y(3));
residual(6)= lhs-rhs;
lhs =y(9);
rhs =y(1)-(y(4)-y(3))*(1-params(1))-T47*(y(6)-y(4));
residual(7)= lhs-rhs;
lhs =y(11);
rhs =(-y(8))+y(9)*params(10)*params(7)/params(3)*params(13)+params(13)*(params(3)-params(7))*y(12)+y(11)*params(13)*(1-params(7));
residual(8)= lhs-rhs;
lhs =y(11);
rhs =(y(6)-y(4))*params(6)*params(7)+y(12)*(1-params(7)/params(3));
residual(9)= lhs-rhs;
lhs =y(2);
rhs =y(5)*params(11)+y(6)*params(12);
residual(10)= lhs-rhs;
lhs =y(2);
rhs =y(1)+y(4)*params(1)+y(3)*(1-params(1));
residual(11)= lhs-rhs;
lhs =y(4);
rhs =y(4)*(1-params(3))+y(6)*params(3);
residual(12)= lhs-rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
if nargout >= 2,
  g1 = zeros(12, 12);

  %
  % Jacobian matrix
  %

  g1(1,1)=1-params(9);
  g1(2,3)=(-params(5));
  g1(2,5)=(-1);
  g1(2,7)=1;
  g1(3,8)=1;
  g1(3,10)=1;
  g1(4,8)=1;
  g1(5,4)=(-1);
  g1(5,6)=1;
  g1(5,11)=(-1);
  g1(6,1)=(-1);
  g1(6,3)=params(1);
  g1(6,4)=(-params(1));
  g1(6,7)=1;
  g1(7,1)=(-1);
  g1(7,3)=(-(1-params(1)));
  g1(7,4)=(-((-(1-params(1)))-(-T47)));
  g1(7,6)=T47;
  g1(7,9)=1;
  g1(8,8)=1;
  g1(8,9)=(-(params(10)*params(7)/params(3)*params(13)));
  g1(8,11)=1-params(13)*(1-params(7));
  g1(8,12)=(-(params(13)*(params(3)-params(7))));
  g1(9,4)=params(6)*params(7);
  g1(9,6)=(-(params(6)*params(7)));
  g1(9,11)=1;
  g1(9,12)=(-(1-params(7)/params(3)));
  g1(10,2)=1;
  g1(10,5)=(-params(11));
  g1(10,6)=(-params(12));
  g1(11,1)=(-1);
  g1(11,2)=1;
  g1(11,3)=(-(1-params(1)));
  g1(11,4)=(-params(1));
  g1(12,4)=1-(1-params(3));
  g1(12,6)=(-params(3));
  if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
  end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],12,144);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],12,1728);
end
end
end
end
