function residual = static_resid(T, y, x, params, T_flag)
% function residual = static_resid(T, y, x, params, T_flag)
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
%   residual
%

if T_flag
    T = NK_CGG99.static_resid_tt(T, y, x, params);
end
residual = zeros(24, 1);
lhs = y(4);
rhs = y(2)*4;
residual(1) = lhs - rhs;
lhs = y(5);
rhs = y(3)+y(3)+y(3)+y(3);
residual(2) = lhs - rhs;
lhs = y(6);
rhs = 4*y(3);
residual(3) = lhs - rhs;
lhs = y(7);
rhs = y(1);
residual(4) = lhs - rhs;
lhs = y(4);
rhs = params(32)*x(3)+y(7)*params(22)+y(7)*params(21)+y(7)*params(20)+y(7)*params(19)+y(7)*params(18)+y(7)*params(17)+y(7)*params(16)+y(7)*params(15)+y(7)*params(14)+y(6)*params(13)+y(6)*params(12)+y(6)*params(11)+y(6)*params(10)+y(6)*params(6)+y(6)*params(5)+y(4)*params(1)+y(4)*params(2)+y(4)*params(3)+y(4)*params(4)+y(6)*params(7)+y(6)*params(8)+y(6)*params(9);
residual(5) = lhs - rhs;
lhs = y(1);
rhs = params(36)*(y(2)-y(3))+y(1)*params(35)+y(1)*(1-params(35))+x(2);
residual(6) = lhs - rhs;
lhs = y(3);
rhs = y(1)*params(38)+y(3)*params(37)+y(3)*(1-params(37))*params(39)+x(1);
residual(7) = lhs - rhs;
lhs = y(8);
rhs = y(6);
residual(8) = lhs - rhs;
lhs = y(9);
rhs = y(6);
residual(9) = lhs - rhs;
lhs = y(10);
rhs = y(6);
residual(10) = lhs - rhs;
lhs = y(11);
rhs = y(7);
residual(11) = lhs - rhs;
lhs = y(12);
rhs = y(7);
residual(12) = lhs - rhs;
lhs = y(13);
rhs = y(7);
residual(13) = lhs - rhs;
lhs = y(14);
rhs = y(3);
residual(14) = lhs - rhs;
lhs = y(15);
rhs = y(3);
residual(15) = lhs - rhs;
lhs = y(16);
rhs = y(7);
residual(16) = lhs - rhs;
lhs = y(17);
rhs = y(7);
residual(17) = lhs - rhs;
lhs = y(18);
rhs = y(7);
residual(18) = lhs - rhs;
lhs = y(19);
rhs = y(4);
residual(19) = lhs - rhs;
lhs = y(20);
rhs = y(4);
residual(20) = lhs - rhs;
lhs = y(21);
rhs = y(4);
residual(21) = lhs - rhs;
lhs = y(22);
rhs = y(6);
residual(22) = lhs - rhs;
lhs = y(23);
rhs = y(6);
residual(23) = lhs - rhs;
lhs = y(24);
rhs = y(6);
residual(24) = lhs - rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
end
