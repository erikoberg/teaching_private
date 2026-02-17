function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(5, 1);
  y(15)=y(13)+params(5)*y(11);
  y(10)=y(9)+params(1)*y(12)+y(11)*(1-params(1));
  residual(1)=(y(15))-(y(9)+params(1)*(y(12)-y(11)));
  residual(2)=(y(10))-(y(13)*params(9)+params(10)*y(14));
  residual(3)=(y(12))-((1-params(3))*y(4)+params(3)*y(6));
  residual(4)=(y(13))-((-(params(8)/(params(8)+1-params(3))))*y(24)+y(21));
  residual(5)=(y(16))-(y(9)-(1-params(1))*(y(12)-y(11)));
if nargout > 3
    g1_v = NaN(16, 1);
g1_v(1)=(-params(3));
g1_v(2)=(-(1-params(3)));
g1_v(3)=params(5)+params(1);
g1_v(4)=1-params(1);
g1_v(5)=(-(1-params(1)));
g1_v(6)=(-params(10));
g1_v(7)=(-params(1));
g1_v(8)=params(1);
g1_v(9)=1;
g1_v(10)=1-params(1);
g1_v(11)=1;
g1_v(12)=(-params(9));
g1_v(13)=1;
g1_v(14)=1;
g1_v(15)=(-1);
g1_v(16)=params(8)/(params(8)+1-params(3));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 15);
end
end
