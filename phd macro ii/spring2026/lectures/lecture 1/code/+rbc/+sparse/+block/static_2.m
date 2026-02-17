function [y, T, residual, g1] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(7, 1);
  residual(1)=(y(7))-(y(5)+params(5)*y(3));
  residual(2)=(y(5))-(y(5)+(-(params(8)/(params(8)+1-params(3))))*y(8));
  residual(3)=(y(2))-(y(5)*params(9)+params(10)*y(6));
  residual(4)=(y(2))-(y(1)+params(1)*y(4)+y(3)*(1-params(1)));
  residual(5)=(y(4))-((1-params(3))*y(4)+params(3)*y(6));
  residual(6)=(y(8))-(y(1)-(1-params(1))*(y(4)-y(3)));
  residual(7)=(y(7))-(y(1)+params(1)*(y(4)-y(3)));
if nargout > 3
    g1_v = NaN(18, 1);
g1_v(1)=1;
g1_v(2)=1;
g1_v(3)=params(8)/(params(8)+1-params(3));
g1_v(4)=1;
g1_v(5)=(-1);
g1_v(6)=(-params(9));
g1_v(7)=1;
g1_v(8)=1;
g1_v(9)=(-params(10));
g1_v(10)=(-params(3));
g1_v(11)=(-params(5));
g1_v(12)=(-(1-params(1)));
g1_v(13)=(-(1-params(1)));
g1_v(14)=params(1);
g1_v(15)=(-params(1));
g1_v(16)=1-(1-params(3));
g1_v(17)=1-params(1);
g1_v(18)=(-params(1));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 7, 7);
end
end
