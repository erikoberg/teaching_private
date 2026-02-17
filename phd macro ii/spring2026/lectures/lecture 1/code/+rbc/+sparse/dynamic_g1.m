function [g1, T_order, T] = dynamic_g1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 9
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = rbc.sparse.dynamic_g1_tt(y, x, params, steady_state, T_order, T);
g1_v = NaN(27, 1);
g1_v(1)=(-params(7));
g1_v(2)=(-(1-params(3)));
g1_v(3)=(-params(3));
g1_v(4)=1;
g1_v(5)=(-1);
g1_v(6)=(-1);
g1_v(7)=(-1);
g1_v(8)=1;
g1_v(9)=1;
g1_v(10)=(-params(5));
g1_v(11)=(-(1-params(1)));
g1_v(12)=(-(1-params(1)));
g1_v(13)=params(1);
g1_v(14)=(-params(1));
g1_v(15)=1;
g1_v(16)=1-params(1);
g1_v(17)=(-params(1));
g1_v(18)=(-1);
g1_v(19)=1;
g1_v(20)=(-params(9));
g1_v(21)=(-params(10));
g1_v(22)=1;
g1_v(23)=1;
g1_v(24)=1;
g1_v(25)=(-1);
g1_v(26)=params(8)/(params(8)+1-params(3));
g1_v(27)=(-1);
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 8, 25);
end
