function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = NK_CGG99.static_g1_tt(T, y, x, params);
end
g1 = zeros(24, 24);
g1(1,2)=(-4);
g1(1,4)=1;
g1(2,3)=(-4);
g1(2,5)=1;
g1(3,3)=(-4);
g1(3,6)=1;
g1(4,1)=(-1);
g1(4,7)=1;
g1(5,4)=1-(params(4)+params(3)+params(1)+params(2));
g1(5,6)=(-(params(13)+params(12)+params(11)+params(10)+params(9)+params(8)+params(7)+params(6)+params(5)));
g1(5,7)=(-(params(22)+params(21)+params(20)+params(19)+params(18)+params(17)+params(16)+params(15)+params(14)));
g1(6,2)=(-params(36));
g1(6,3)=params(36);
g1(7,1)=(-params(38));
g1(7,3)=1-(params(37)+(1-params(37))*params(39));
g1(8,6)=(-1);
g1(8,8)=1;
g1(9,6)=(-1);
g1(9,9)=1;
g1(10,6)=(-1);
g1(10,10)=1;
g1(11,7)=(-1);
g1(11,11)=1;
g1(12,7)=(-1);
g1(12,12)=1;
g1(13,7)=(-1);
g1(13,13)=1;
g1(14,3)=(-1);
g1(14,14)=1;
g1(15,3)=(-1);
g1(15,15)=1;
g1(16,7)=(-1);
g1(16,16)=1;
g1(17,7)=(-1);
g1(17,17)=1;
g1(18,7)=(-1);
g1(18,18)=1;
g1(19,4)=(-1);
g1(19,19)=1;
g1(20,4)=(-1);
g1(20,20)=1;
g1(21,4)=(-1);
g1(21,21)=1;
g1(22,6)=(-1);
g1(22,22)=1;
g1(23,6)=(-1);
g1(23,23)=1;
g1(24,6)=(-1);
g1(24,24)=1;
if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
end
end
