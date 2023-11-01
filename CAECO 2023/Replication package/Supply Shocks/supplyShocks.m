%% Clarida, Galí, and Gertler (1999)

clear all;

% Load model
dynare NK_CGG99

%% General setUp

dates = 0:20;
var_list = [];
options_.irf = 20;
options_.nodisplay = true;
options_.relative_irf = true;

set_param_value('theta', 0); % Phillips curve is forward-looking


%% Simulate phi = 0

phiVal = 0;

% Original Taylor Rule
set_param_value('phi', phiVal);   % Inflation persistence on the Phillips curve
set_param_value('cofintinfb3', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb2', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb1', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinf0', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintout', 0.5); % OutputGap-reaction on the Taylor rule
[info, oo_Policy1, options_, M_] = stoch_simul(M_, options_, oo_, var_list);

% Accommodative Taylor Rule
set_param_value('phi', phiVal);   % Inflation persistence on the Phillips curve
set_param_value('cofintinfb3', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb2', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb1', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinf0', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintout', 4.0); % OutputGap-reaction on the Taylor rule
[info, oo_Policy2, options_, M_] = stoch_simul(M_, options_, oo_, var_list);

phiVal = 0.5;

% Original Taylor Rule
set_param_value('phi', phiVal);   % Inflation persistence on the Phillips curve
set_param_value('cofintinfb3', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb2', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb1', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinf0', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintout', 0.5); % OutputGap-reaction on the Taylor rule
[info, oo_Policy3, options_, M_] = stoch_simul(M_, options_, oo_, var_list);

% Accommodative Taylor Rule
set_param_value('phi', phiVal);   % Inflation persistence on the Phillips curve
set_param_value('cofintinfb3', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb2', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb1', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinf0', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintout', 4.0); % OutputGap-reaction on the Taylor rule
[info, oo_Policy4, options_, M_] = stoch_simul(M_, options_, oo_, var_list);

phiVal = 0.8;

% Original Taylor Rule
set_param_value('phi', phiVal);   % Inflation persistence on the Phillips curve
set_param_value('cofintinfb3', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb2', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb1', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinf0', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintout', 0.5); % OutputGap-reaction on the Taylor rule
[info, oo_Policy5, options_, M_] = stoch_simul(M_, options_, oo_, var_list);

% Accommodative Taylor Rule
set_param_value('phi', phiVal);   % Inflation persistence on the Phillips curve
set_param_value('cofintinfb3', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb2', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinfb1', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintinf0', 0.375); % Inflation-reaction on the Taylor rule
set_param_value('cofintout', 4.0); % OutputGap-reaction on the Taylor rule
[info, oo_Policy6, options_, M_] = stoch_simul(M_, options_, oo_, var_list);


%% Plot ROW 1
close all;
figure;
idx = 0;

irf_i = [0, 0; [oo_Policy1.irfs.interest_inflation_', oo_Policy2.irfs.interest_inflation_']] / 100;
irf_pi = [0, 0; [oo_Policy1.irfs.inflation_inflation_', oo_Policy2.irfs.inflation_inflation_']] / 100;
irf_outputGap = [0, 0; [oo_Policy1.irfs.outputgap_inflation_', oo_Policy2.irfs.outputgap_inflation_']] / 100;

xi = [dates(1):0.001:dates(end)];
irf_i = interp1(dates, irf_i, xi,'spline');
irf_pi = interp1(dates, irf_pi, xi,'spline');
irf_outputGap = interp1(dates, irf_outputGap, xi,'spline');

yZero = zeros(length(xi),1);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_pi, 'LineWidth', 2);
title('Inflação');
ylabel({'100% prospectivo', 'desvio do e.e. (p.p.)'}, 'FontSize', 12, 'FontWeight','bold');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_i, 'LineWidth', 2);
title('Taxa nominal de juros');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_outputGap, 'LineWidth', 2)
title('Hiato do produto');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);


%% Plot ROW 2

irf_i = [0, 0; [oo_Policy3.irfs.interest_inflation_', oo_Policy4.irfs.interest_inflation_']] / 100;
irf_pi = [0, 0; [oo_Policy3.irfs.inflation_inflation_', oo_Policy4.irfs.inflation_inflation_']] / 100;
irf_outputGap = [0, 0; [oo_Policy3.irfs.outputgap_inflation_', oo_Policy4.irfs.outputgap_inflation_']] / 100;

xi = [dates(1):0.001:dates(end)];
irf_i = interp1(dates, irf_i, xi,'spline');
irf_pi = interp1(dates, irf_pi, xi,'spline');
irf_outputGap = interp1(dates, irf_outputGap, xi,'spline');

yZero = zeros(length(xi),1);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_pi, 'LineWidth', 2);
title('Inflação');
ylabel({'50% prospectivo', 'desvio do e.e. (p.p.)'}, 'FontSize', 12, 'FontWeight','bold');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_i, 'LineWidth', 2);
title('Taxa nominal de juros');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_outputGap, 'LineWidth', 2)
title('Hiato do produto');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);


%% Plot ROW 3

irf_i = [0, 0; [oo_Policy5.irfs.interest_inflation_', oo_Policy6.irfs.interest_inflation_']] / 100;
irf_pi = [0, 0; [oo_Policy5.irfs.inflation_inflation_', oo_Policy6.irfs.inflation_inflation_']] / 100;
irf_outputGap = [0, 0; [oo_Policy5.irfs.outputgap_inflation_', oo_Policy6.irfs.outputgap_inflation_']] / 100;

xi = [dates(1):0.001:dates(end)];
irf_i = interp1(dates, irf_i, xi,'spline');
irf_pi = interp1(dates, irf_pi, xi,'spline');
irf_outputGap = interp1(dates, irf_outputGap, xi,'spline');

yZero = zeros(length(xi),1);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_pi, 'LineWidth', 2);
title('Inflação');
ylabel({'20% prospectivo', 'desvio do e.e. (p.p.)'}, 'FontSize', 12, 'FontWeight','bold');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_i, 'LineWidth', 2);
title('Taxa nominal de juros');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);

idx = idx + 1;
subplot(3,3,idx); 
plot(xi, irf_outputGap, 'LineWidth', 2)
title('Hiato do produto');
grid('on');
hold on; plot(xi, yZero, 'LineStyle', '--', 'Color', 'black', 'LineWidth', 2);
