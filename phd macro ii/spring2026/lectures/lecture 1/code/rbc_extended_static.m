function [residual, g1, g2, g3] = rbc_extended_static(y, x, params)
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

residual = zeros( 11, 1);

%
% Model equations
%

lhs =y(1);
rhs =y(1)*params(9)+x(1);
residual(1)= lhs-rhs;
lhs =y(9);
rhs =params(5)/params(4)*y(11);
residual(2)= lhs-rhs;
lhs =y(10);
rhs =params(4)/params(3);
residual(3)= lhs-rhs;
lhs =y(8);
rhs =y(6)+params(7)*y(3);
residual(4)= lhs-rhs;
lhs =y(6);
rhs =y(6)+y(9)*(-params(2))*params(10)-y(11)*params(3)*params(4)*params(2);
residual(5)= lhs-rhs;
lhs =y(2);
rhs =y(6)*params(11)+params(12)*y(7);
residual(6)= lhs-rhs;
lhs =y(2);
rhs =y(1)+params(1)*y(5)+y(3)*(1-params(1));
residual(7)= lhs-rhs;
lhs =y(4);
rhs =y(4)*(1-params(3))-params(4)*y(11)+params(3)*y(7);
residual(8)= lhs-rhs;
lhs =y(9);
rhs =y(1)-(1-params(1))*(y(5)-y(3));
residual(9)= lhs-rhs;
lhs =y(8);
rhs =y(1)+params(1)*(y(5)-y(3));
residual(10)= lhs-rhs;
lhs =y(5);
rhs =y(11)+y(4);
residual(11)= lhs-rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
if nargout >= 2,
  g1 = zeros(11, 11);

  %
  % Jacobian matrix
  %

  g1(1,1)=1-params(9);
  g1(2,9)=1;
  g1(2,11)=(-(params(5)/params(4)));
  g1(3,10)=1;
  g1(4,3)=(-params(7));
  g1(4,6)=(-1);
  g1(4,8)=1;
  g1(5,9)=(-((-params(2))*params(10)));
  g1(5,11)=params(3)*params(4)*params(2);
  g1(6,2)=1;
  g1(6,6)=(-params(11));
  g1(6,7)=(-params(12));
  g1(7,1)=(-1);
  g1(7,2)=1;
  g1(7,3)=(-(1-params(1)));
  g1(7,5)=(-params(1));
  g1(8,4)=1-(1-params(3));
  g1(8,7)=(-params(3));
  g1(8,11)=params(4);
  g1(9,1)=(-1);
  g1(9,3)=(-(1-params(1)));
  g1(9,5)=1-params(1);
  g1(9,9)=1;
  g1(10,1)=(-1);
  g1(10,3)=params(1);
  g1(10,5)=(-params(1));
  g1(10,8)=1;
  g1(11,4)=(-1);
  g1(11,5)=1;
  g1(11,11)=(-1);
  if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
  end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],11,121);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],11,1331);
end
end
end
end
