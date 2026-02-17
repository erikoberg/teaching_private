function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = rbc.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(8, 1);
    residual(1) = (y(9)) - (params(7)*y(1)+x(1));
    residual(2) = (y(15)) - (y(13)+params(5)*y(11));
    residual(3) = (y(13)) - ((-(params(8)/(params(8)+1-params(3))))*y(24)+y(21));
    residual(4) = (y(10)) - (y(13)*params(9)+params(10)*y(14));
    residual(5) = (y(10)) - (y(9)+params(1)*y(12)+y(11)*(1-params(1)));
    residual(6) = (y(12)) - ((1-params(3))*y(4)+params(3)*y(6));
    residual(7) = (y(16)) - (y(9)-(1-params(1))*(y(12)-y(11)));
    residual(8) = (y(15)) - (y(9)+params(1)*(y(12)-y(11)));
end
