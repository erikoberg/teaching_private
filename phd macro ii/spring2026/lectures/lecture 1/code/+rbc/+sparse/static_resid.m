function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = rbc.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(8, 1);
    residual(1) = (y(1)) - (y(1)*params(7)+x(1));
    residual(2) = (y(7)) - (y(5)+params(5)*y(3));
    residual(3) = (y(5)) - (y(5)+(-(params(8)/(params(8)+1-params(3))))*y(8));
    residual(4) = (y(2)) - (y(5)*params(9)+params(10)*y(6));
    residual(5) = (y(2)) - (y(1)+params(1)*y(4)+y(3)*(1-params(1)));
    residual(6) = (y(4)) - ((1-params(3))*y(4)+params(3)*y(6));
    residual(7) = (y(8)) - (y(1)-(1-params(1))*(y(4)-y(3)));
    residual(8) = (y(7)) - (y(1)+params(1)*(y(4)-y(3)));
end
