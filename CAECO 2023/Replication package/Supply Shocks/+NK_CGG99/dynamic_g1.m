function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
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
%   g1
%

if T_flag
    T = NK_CGG99.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(24, 53);
g1(1,18)=(-4);
g1(1,20)=1;
g1(2,2)=(-1);
g1(2,19)=(-1);
g1(2,21)=1;
g1(2,6)=(-1);
g1(2,7)=(-1);
g1(3,19)=(-4);
g1(3,22)=1;
g1(4,17)=(-1);
g1(4,23)=1;
g1(5,3)=(-params(1));
g1(5,20)=1;
g1(5,4)=(-params(6));
g1(5,22)=(-params(5));
g1(5,43)=(-params(10));
g1(5,5)=(-params(15));
g1(5,23)=(-params(14));
g1(5,44)=(-params(19));
g1(5,53)=(-params(32));
g1(5,45)=(-params(11));
g1(5,46)=(-params(12));
g1(5,47)=(-params(13));
g1(5,48)=(-params(20));
g1(5,49)=(-params(21));
g1(5,50)=(-params(22));
g1(5,8)=(-params(16));
g1(5,9)=(-params(17));
g1(5,10)=(-params(18));
g1(5,11)=(-params(2));
g1(5,12)=(-params(3));
g1(5,13)=(-params(4));
g1(5,14)=(-params(7));
g1(5,15)=(-params(8));
g1(5,16)=(-params(9));
g1(6,1)=(-params(35));
g1(6,17)=1;
g1(6,41)=(-(1-params(35)));
g1(6,18)=(-params(36));
g1(6,42)=params(36);
g1(6,52)=(-1);
g1(7,17)=(-params(38));
g1(7,2)=(-params(37));
g1(7,19)=1;
g1(7,42)=(-((1-params(37))*params(39)));
g1(7,51)=(-1);
g1(8,43)=(-1);
g1(8,24)=1;
g1(9,45)=(-1);
g1(9,25)=1;
g1(10,46)=(-1);
g1(10,26)=1;
g1(11,44)=(-1);
g1(11,27)=1;
g1(12,48)=(-1);
g1(12,28)=1;
g1(13,49)=(-1);
g1(13,29)=1;
g1(14,2)=(-1);
g1(14,30)=1;
g1(15,6)=(-1);
g1(15,31)=1;
g1(16,5)=(-1);
g1(16,32)=1;
g1(17,8)=(-1);
g1(17,33)=1;
g1(18,9)=(-1);
g1(18,34)=1;
g1(19,3)=(-1);
g1(19,35)=1;
g1(20,11)=(-1);
g1(20,36)=1;
g1(21,12)=(-1);
g1(21,37)=1;
g1(22,4)=(-1);
g1(22,38)=1;
g1(23,14)=(-1);
g1(23,39)=1;
g1(24,15)=(-1);
g1(24,40)=1;

end
