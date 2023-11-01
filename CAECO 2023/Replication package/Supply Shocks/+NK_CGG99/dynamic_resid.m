function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = NK_CGG99.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(24, 1);
lhs = y(20);
rhs = y(18)*4;
residual(1) = lhs - rhs;
lhs = y(21);
rhs = y(19)+y(2)+y(6)+y(7);
residual(2) = lhs - rhs;
lhs = y(22);
rhs = 4*y(19);
residual(3) = lhs - rhs;
lhs = y(23);
rhs = y(17);
residual(4) = lhs - rhs;
lhs = y(20);
rhs = params(32)*x(it_, 3)+params(22)*y(50)+params(21)*y(49)+params(20)*y(48)+params(19)*y(44)+params(18)*y(10)+params(17)*y(9)+params(16)*y(8)+params(15)*y(5)+y(23)*params(14)+params(13)*y(47)+params(12)*y(46)+params(11)*y(45)+params(10)*y(43)+params(6)*y(4)+y(22)*params(5)+params(1)*y(3)+params(2)*y(11)+params(3)*y(12)+params(4)*y(13)+params(7)*y(14)+params(8)*y(15)+params(9)*y(16);
residual(5) = lhs - rhs;
lhs = y(17);
rhs = params(36)*(y(18)-y(42))+params(35)*y(1)+(1-params(35))*y(41)+x(it_, 2);
residual(6) = lhs - rhs;
lhs = y(19);
rhs = y(17)*params(38)+y(2)*params(37)+y(42)*(1-params(37))*params(39)+x(it_, 1);
residual(7) = lhs - rhs;
lhs = y(24);
rhs = y(43);
residual(8) = lhs - rhs;
lhs = y(25);
rhs = y(45);
residual(9) = lhs - rhs;
lhs = y(26);
rhs = y(46);
residual(10) = lhs - rhs;
lhs = y(27);
rhs = y(44);
residual(11) = lhs - rhs;
lhs = y(28);
rhs = y(48);
residual(12) = lhs - rhs;
lhs = y(29);
rhs = y(49);
residual(13) = lhs - rhs;
lhs = y(30);
rhs = y(2);
residual(14) = lhs - rhs;
lhs = y(31);
rhs = y(6);
residual(15) = lhs - rhs;
lhs = y(32);
rhs = y(5);
residual(16) = lhs - rhs;
lhs = y(33);
rhs = y(8);
residual(17) = lhs - rhs;
lhs = y(34);
rhs = y(9);
residual(18) = lhs - rhs;
lhs = y(35);
rhs = y(3);
residual(19) = lhs - rhs;
lhs = y(36);
rhs = y(11);
residual(20) = lhs - rhs;
lhs = y(37);
rhs = y(12);
residual(21) = lhs - rhs;
lhs = y(38);
rhs = y(4);
residual(22) = lhs - rhs;
lhs = y(39);
rhs = y(14);
residual(23) = lhs - rhs;
lhs = y(40);
rhs = y(15);
residual(24) = lhs - rhs;

end
