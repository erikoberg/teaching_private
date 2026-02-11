function [residual, g1, g2, g3] = rbc_adjcost_static(y, x, params)
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

residual = zeros( 9, 1);

%
% Model equations
%

T37 = params(2)*params(6)*params(3)^2;
lhs =y(1);
rhs =y(1)*params(8)+x(1);
residual(1)= lhs-rhs;
lhs =y(7);
rhs =y(5)+params(5)*y(3);
residual(2)= lhs-rhs;
lhs =y(5)-y(9);
rhs =y(5)+(-params(2))*params(9)*y(8)-y(9)*params(2)*(1-params(3))-T37*(y(6)-y(4));
residual(3)= lhs-rhs;
lhs =y(9);
rhs =(y(6)-y(4))*params(3)*params(6);
residual(4)= lhs-rhs;
lhs =y(2);
rhs =y(5)*params(10)+y(6)*params(11);
residual(5)= lhs-rhs;
lhs =y(2);
rhs =y(1)+y(4)*params(1)+y(3)*(1-params(1));
residual(6)= lhs-rhs;
lhs =y(4);
rhs =(1-params(3))*y(4)+params(3)*y(6);
residual(7)= lhs-rhs;
lhs =y(8);
rhs =y(1)-(1-params(1))*(y(4)-y(3));
residual(8)= lhs-rhs;
lhs =y(7);
rhs =y(1)+params(1)*(y(4)-y(3));
residual(9)= lhs-rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
if nargout >= 2,
  g1 = zeros(9, 9);

  %
  % Jacobian matrix
  %

  g1(1,1)=1-params(8);
  g1(2,3)=(-params(5));
  g1(2,5)=(-1);
  g1(2,7)=1;
  g1(3,4)=(-T37);
  g1(3,6)=T37;
  g1(3,8)=(-((-params(2))*params(9)));
  g1(3,9)=(-1)-(-(params(2)*(1-params(3))));
  g1(4,4)=params(3)*params(6);
  g1(4,6)=(-(params(3)*params(6)));
  g1(4,9)=1;
  g1(5,2)=1;
  g1(5,5)=(-params(10));
  g1(5,6)=(-params(11));
  g1(6,1)=(-1);
  g1(6,2)=1;
  g1(6,3)=(-(1-params(1)));
  g1(6,4)=(-params(1));
  g1(7,4)=1-(1-params(3));
  g1(7,6)=(-params(3));
  g1(8,1)=(-1);
  g1(8,3)=(-(1-params(1)));
  g1(8,4)=1-params(1);
  g1(8,8)=1;
  g1(9,1)=(-1);
  g1(9,3)=params(1);
  g1(9,4)=(-params(1));
  g1(9,7)=1;
  if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
  end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],9,81);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],9,729);
end
end
end
end
