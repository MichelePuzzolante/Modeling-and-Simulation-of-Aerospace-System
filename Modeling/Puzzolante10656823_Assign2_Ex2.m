% Modeling and Simulation of Aerospace Systems (2024/2025)
% Assignment # 2
% Author : Michele Puzzolante
%% EXERCISE 2
% Initializzation of the workspace
clear;
close all;
clc;

% Set default options for plots
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');

fprintf('\n EXERCISE 2\n')

% Variable used for saving the plots
SAVEPLOTS = false;

% Accelerometer parameters
param.ACC.Msc = 300;        % S/C mass       [kg]
param.ACC.ma = 0.32;        % Seismic mass   [kg]
param.ACC.ba = 1.5e3;       % Acc damper     [Ns/m]
param.ACC.ka = 5e-5;        % Acc spring     [N/m]
param.ACC.Kacc = 1;         % Acc prop coeff [Vs/N]

% Amplifier parameters
param.AMP.Rin = 0.1;        % Inverting reistance [Ohm]
param.AMP.Rf = 5e4;         % Feedback reistance  [Ohm]

% Solenoidal valve parameters
param.SOLV.mv = 0.1;        % Spool mass         [kg]
param.SOLV.bv = 1e3;        % Valve damper       [Ns/m]
param.SOLV.kv = 1e3;        % Valve spring       [N/m]
param.SOLV.alpha = 2.1e-2;  % Solenoid constants [1/H]
param.SOLV.beta = -60;      % Solenoid gain      [1/Hm]
param.SOLV.A0 = 4.7e-12;    % Minimum area       [m^2]
param.SOLV.xv_max = 1e-5;   % Maximum extension  [m]
% Inductance function [H]
param.SOLV.L = @(xv) 1 / (param.SOLV.alpha + param.SOLV.beta * xv);
% Derivative of the inductance w.r.t. xv [H/m]
param.SOLV.dLdxv = @(xv) -param.SOLV.beta / (param.SOLV.alpha + param.SOLV.beta * xv)^2;

% Thruster parameters
param.THR.k = 1.66;         % Heat ratio       [-]
param.THR.pT = 2e5;         % Tank pressure    [Pa]
param.THR.TT = 240;         % Tank temperature [K]
param.THR.R = 63.32754;     % Gas constants    [J/kg K]
param.THR.q = 1.6e-19;      % Charge           [C]
param.THR.V = 2000;         % Volatge          [V]
param.THR.mi = 2.188e-25;   % Ion Mass         [kg]
% Function of the orifice area [m^2]
param.THR.A = @(xv) param.SOLV.A0 + param.SOLV.xv_max * (param.SOLV.xv_max - xv);

% Drag parameters
param.D.D0 = 2.2;               % D0
param.D.D1 = 1.2;               % D1
param.D.omega_s = 1.658226e-6;  % Secular pulsation [rad/s]
param.D.omega_0 = 1.160758e-3;  % Orbital pulsation [rad/s]
% Drag function [mN]
param.D.D = @(t) (param.D.D0 - cos(param.D.omega_s * t) + param.D.D1 * sin(param.D.omega_0 * t) .* cos(param.D.omega_0 * t)) * 1e-3;

% Time
T_orb = 2 * pi/param.D.omega_0; % Orbital period [s]
t0 = 0;                     % Initial time   [s]
tf = T_orb * 3;                 % Final time   [s] 

fprintf('\nT_orb = %.3f [s], %.3f [h]', T_orb, T_orb/3600)

% Initial condition
xa0 = 0;
va0 = 0;
xv0 = fzero(@(xv) param.D.D(0) - ionThruster(xv, param), 0);
vv0 = 0;
I0  = fzero(@(I) - param.SOLV.kv * xv0 + 1/2 * I^2 * param.SOLV.dLdxv(xv0), 0);

% Display initial conditions
fprintf('\nINITIAL CONDITION')
fprintf('\nxv0 = %.6e [m]', xv0)
fprintf('\nI0 = %.6e [A]', I0)

% assemble initial conditions vector
yy0 = [xa0; va0; xv0; vv0; I0];

% Integration
[tt, yy] = systemPropagation([t0 tf], yy0, param);

% Extract variables from the state
xa = yy(:, 1);
va = yy(:, 2);
xv = yy(:, 3);
vv = yy(:, 4);
I =  yy(:, 5);

% Computation of the Thrust
T = ionThruster(yy(:, 3), param);

% Conversion of time vector
tt_T = tt/3600;

% Plot xa
figure(1)
plot(tt_T, xa*1e9, 'LineWidth', 2, 'Color', [0 0.4470 0.7410])
ylabel('$x_a$ [nm]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot va
figure(2)
plot(tt_T, va*1e9, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980])
ylabel('$v_a$ [nm/s]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot xv
figure(3)
plot(tt_T, xv*1e6, 'LineWidth', 2, 'Color', [0.4660 0.6740 0.1880])
hold on
yline(param.SOLV.xv_max*1e6, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'x_v_{max}', 'LabelVerticalAlignment','bottom')
yline(0, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'x_v_{min}', 'LabelVerticalAlignment','top')
ylabel('$x_v$ [$\mu$m]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot vv
figure(4)
plot(tt_T, vv*1e6, 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
ylabel('$v_v$ [$\mu$m/s]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot I
figure(5)
plot(tt_T, I*1e3, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
ylabel('I [mA]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot T - D
figure(6)
plot(tt_T, param.D.D(tt)*1e3, 'LineWidth', 2, 'Color', [0 1 1])
hold on
plot(tt_T, T*1e3, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
yline(ionThruster(param.SOLV.xv_max, param)*1e3, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'T_{min}', 'LabelVerticalAlignment','top')
yline(ionThruster(0, param)*1e3, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'T_{max}', 'LabelVerticalAlignment','bottom')
xlabel('Time [h]')
ylabel('T, D [mN]')
legend('Drag', 'Thrust', 'Location', 'northwest')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot T - D
figure(7)
semilogy(tt_T, abs((T-param.D.D(tt))*1e3), 'LineWidth', 2, 'Color', [1 0 0])
xlabel('Time [h]')
ylabel('(T -D) [mN]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'xa_matlab.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'va_matlab.png','Resolution',600);

    % Saving 3rd figure
    figure(3)
    exportgraphics(gcf,'xv_matlab.png','Resolution',600);

    % Saving 4th figure
    figure(4)
    exportgraphics(gcf,'vv_matlab.png','Resolution',600);

    % Saving 5th figure
    figure(5)
    exportgraphics(gcf,'I_matlab.png','Resolution',600);

    % Saving 6th figure
    figure(6)
    exportgraphics(gcf,'T_D_matlab.png','Resolution',600);

    % Saving 7th figure
    figure(7)
    exportgraphics(gcf,'error_T_D_matlab.png','Resolution',600);

end

%% SIMSCAPE MODEL

% Simulation
simOut = sim('Puzzolante10656823_Assign2_Ex2_Simscape.slx');

% Extract time vector
tt_simscape = simOut.tout;

% Conversion of time vector
tt_T_simscape = tt_simscape/3600;

% Extract variables from the result of the simulation
xa_simscape = simOut.xa_simscape.signals.values;
va_simscape = simOut.va_simscape.signals.values;
xv_simscape = simOut.xv_simscape.signals.values;
vv_simscape = simOut.vv_simscape.signals.values;
I_simscape =  simOut.I_simscape.signals.values;
T_simscape =  simOut.T_simscape.signals.values;
D_simscape =  simOut.D_simscape.signals.values;

% Plot xa
figure(8)
plot(tt_T_simscape, xa_simscape*1e9, 'LineWidth', 2, 'Color', 	[0 0 1])
ylabel('$x_a$ [nm]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot va
figure(9)
plot(tt_T_simscape, va_simscape*1e9, 'LineWidth', 2, 'Color', [1 0.5 0])
ylabel('$v_a$ [nm/s]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot xv
figure(10)
plot(tt_T_simscape, xv_simscape*1e6, 'LineWidth', 2, 'Color', [0 1 0])
hold on
yline(param.SOLV.xv_max*1e6, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'x_v_{max}', 'LabelVerticalAlignment','bottom')
yline(0, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'x_v_{min}', 'LabelVerticalAlignment','top')
ylabel('$x_v$ [$\mu$m]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot vv
figure(11)
plot(tt_T_simscape, vv_simscape*1e6, 'LineWidth', 2, 'Color',  [0 1 1])
ylabel('$v_v$ [$\mu$m/s]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot I
figure(12)
plot(tt_T_simscape, I_simscape*1e3, 'LineWidth', 2, 'Color', [1 0 0])
ylabel('I [mA]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot T - D
figure(13)
plot(tt_T_simscape, D_simscape*1e3, 'LineWidth', 2, 'Color',[0 1 1])
hold on
plot(tt_T_simscape, T_simscape*1e3, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
yline(ionThruster(param.SOLV.xv_max, param)*1e3, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'T_{min}', 'LabelVerticalAlignment','top')
yline(ionThruster(0, param)*1e3, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'T_{max}', 'LabelVerticalAlignment','bottom')
xlabel('Time [h]')
ylabel('T, D [mN]')
legend('Drag', 'Thrust', 'Location', 'northwest')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot T - D
figure(14)
semilogy(tt_T_simscape, abs((T_simscape - D_simscape)*1e3), 'LineWidth', 2, 'Color', [1 0 0])
xlabel('Time [h]')
ylabel('(T -D) [mN]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Save plots
if SAVEPLOTS

    % Saving 8th figure
    figure(8)
    exportgraphics(gcf,'xa_siscape.png','Resolution',600);

    % Saving 9th figure
    figure(9)
    exportgraphics(gcf,'va_simscape.png','Resolution',600);

    % Saving 10th figure
    figure(10)
    exportgraphics(gcf,'xv_simscape.png','Resolution',600);

    % Saving 11th figure
    figure(11)
    exportgraphics(gcf,'vv_simscape.png','Resolution',600);

    % Saving 12th figure
    figure(12)
    exportgraphics(gcf,'I_simscape.png','Resolution',600);

    % Saving 13th figure
    figure(13)
    exportgraphics(gcf,'T_D_simscape.png','Resolution',600);

    % Saving 14th figure
    figure(14)
    exportgraphics(gcf,'error_T_D_simscape.png','Resolution',600);

end

%% COMPARISON

% Plot xa
figure(15)
plot(tt_T, xa*1e9, 'LineWidth', 2, 'Color', [0 0.4470 0.7410])
hold on
plot(tt_T_simscape, xa_simscape*1e9, 'LineWidth', 2, 'Color', 	[0 0 1], 'LineStyle','--')
ylabel('$x_a$ [nm]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
legend('MATLAB', 'Simscape', 'Location', 'northwest')

% Plot va
figure(16)
plot(tt_T, va*1e9, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980])
hold on
plot(tt_T_simscape, va_simscape*1e9, 'LineWidth', 2, 'Color', [1 0.5 0], 'LineStyle','--')
ylabel('$v_a$ [nm/s]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
legend('MATLAB', 'Simscape')
% Zoom
axes('position',[0.35 0.17 0.5 0.5])
box on 
plot(tt_T, va*1e9, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980])
hold on
plot(tt_T_simscape, va_simscape*1e9, 'LineWidth', 2, 'Color', [1 0.5 0], 'LineStyle','--')
grid on
xlim([0 +Inf])
ylim([-5e-3 5e-3])

% Plot xv
figure(17)
plot(tt_T, xv*1e6, 'LineWidth', 2, 'Color', [0.4660 0.6740 0.1880])
hold on
plot(tt_T_simscape, xv_simscape*1e6, 'LineWidth', 2, 'Color', [0 1 0], 'LineStyle','--')
hold on
yline(param.SOLV.xv_max*1e6, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'x_v_{max}', 'LabelVerticalAlignment','bottom')
yline(0, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'x_v_{min}', 'LabelVerticalAlignment','top')
ylabel('$x_v$ [$\mu$m]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
legend('MATLAB', 'Simscape')

% Plot vv
figure(18)
plot(tt_T, vv*1e6, 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold on
plot(tt_T_simscape, vv_simscape*1e6, 'LineWidth', 2, 'Color', [1 0 1], 'LineStyle','--')
ylabel('$v_v$ [$\mu$m/s]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
legend('MATLAB', 'Simscape')
% Zoom
axes('position',[0.2 0.35 0.5 0.5])
box on 
plot(tt_T, vv*1e6, 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold on
plot(tt_T_simscape, vv_simscape*1e6, 'LineWidth', 2, 'Color', [1 0 1], 'LineStyle','--')
grid on
xlim([0 +Inf])
ylim([-3e-3 3e-3])

% Plot I
figure(19)
plot(tt_T, I*1e3, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
hold on
plot(tt_T_simscape, I_simscape*1e3, 'LineWidth', 2, 'Color', [0 1 1], 'LineStyle','--')
ylabel('I [mA]')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
legend('MATLAB', 'Simscape')

% Plot T
figure(20)
plot(tt_T, T*1e3, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
plot(tt_T_simscape, T_simscape*1e3, 'LineWidth', 2, 'Color', [0 1 1], 'LineStyle','--')
yline(ionThruster(param.SOLV.xv_max, param)*1e3, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'T_{min}', 'LabelVerticalAlignment','top')
yline(ionThruster(0, param)*1e3, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', 'T_{max}', 'LabelVerticalAlignment','bottom')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
ylabel('T [mN]')
legend('MATLAB', 'Simscape', 'Location','northwest')

% Plot T - D
figure(21)
semilogy(tt_T, abs((T-param.D.D(tt))*1e3), 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
semilogy(tt_T_simscape, abs((T_simscape - D_simscape)*1e3), 'LineWidth', 2, 'Color',[0.3010 0.7450 0.9330], 'LineStyle','-')
xlabel('Time [h]')
xlim([0 +Inf])
ylim([-Inf +Inf])
ylabel('(T -D) [mN]')
legend('MATLAB', 'Simscape')

% Plot T - D
figure(22)
plot(tt_T, (T-param.D.D(tt))*1e3, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
plot(tt_T_simscape, (T_simscape - D_simscape)*1e3, 'LineWidth', 2, 'Color',[0.3010 0.7450 0.9330], 'LineStyle','-')
xlabel('Time [h]')
ylabel('(T -D) [mN]')
legend('MATLAB', 'Simscape')
xlim([0 +Inf])
ylim([-1e-2 1e-2])

% Save plots
if SAVEPLOTS

    % Saving 15th figure
    figure(15)
    exportgraphics(gcf,'xa_matlab_vs_siscape.png','Resolution',600);

    % Saving 16th figure
    figure(16)
    exportgraphics(gcf,'va_matlab_vs_simscape.png','Resolution',600);

    % Saving 17th figure
    figure(17)
    exportgraphics(gcf,'xv_matlab_vs_simscape.png','Resolution',600);

    % Saving 18th figure
    figure(18)
    exportgraphics(gcf,'vv_matlab_vs_simscape.png','Resolution',600);

    % Saving 19th figure
    figure(19)
    exportgraphics(gcf,'I_matlab_vs_simscape.png','Resolution',600);

    % Saving 20th figure
    figure(20)
    exportgraphics(gcf,'T_matlab_vs_simscape.png','Resolution',600);

    % Saving 21st figure
    figure(21)
    exportgraphics(gcf,'error_T_D_matlab_vs_simscape_log.png','Resolution',600);

    % Saving 22nd figure
    figure(22)
    exportgraphics(gcf,'error_T_D_matlab_vs_simscape.png','Resolution',600);

end

%% FUNCTIONS

%-------------------------------------------------------------------------%
% function:systemPropagation.m 
function [tt, yy] = systemPropagation(tspan, yy0, param)
%-------------------------------------------------------------------------%
%                                                                         
% systemPropagation: function for propagating the ODEs from t0 to tf
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [tt, yy] = systemPropagation(tspan, yy0, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  tspan        [2x1] initial and final time                [s]
%  yy0          [5x1] initial state                         [m; m/s; m; m/s; A]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  tt           [nx1] Time vector                           [s]
%  yy           [nx5] Solution                              [m; m/s; m; m/s; A] 
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  07/12/2024: First version
%
%-------------------------------------------------------------------------%

% Set tolerances
RelTol = 1e-10;
AbsTol_xxa = 1e-12 * ones(2, 1);
AbsTol_xxv = 1e-12 * ones(2, 1);
AbsTol_I = 1e-12;

% Set options
options = odeset('reltol', RelTol, 'abstol', [AbsTol_xxa; AbsTol_xxv; AbsTol_I]); 

% Perform integration
[tt, yy] = ode15s(@(t, y) systemDynamics(t, y, param), tspan, yy0, options);

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:systemDynamics.m 
function [dydt] = systemDynamics(t, y, param)
%-------------------------------------------------------------------------%
%                                                                         
% systemDynamics: ODEs of the system
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dydt] = systemDynamics(t, y, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [s]
%  y            [5x1] state                                 [m; m/s; m; m/s; A]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dydt         [5x1] ODE                                   [m/s; m/s2; m/s; m/s2; A/s]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  07/12/2024: First version
%
%-------------------------------------------------------------------------%

% ODE of accelorometer
dxadt = accelerometerODE(t, y, param);

% ODE of control valve
dxvdt = controlValveODE(t, y, param);

% Assemble full system of ODEs
dydt = [dxadt; dxvdt];

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:accelerometerODE.m 
function [dxadt] = accelerometerODE(t, y, param)
%-------------------------------------------------------------------------%
%                                                                         
% accelerometerODE: ODEs of the accelerometer
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dxadt] = accelerometerODE(t, xx, xv, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [s]
%  y            [5x1] state                                 [m; m/s; m; m/s; A]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dxadt        [2x1] ODE                                   [m/s; m/s2]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  07/12/2024: First version
%
%-------------------------------------------------------------------------%

% Extract state variables
xx = y(1:2);   % Position and velocity of accelerometer
xv = y(3);     % Position of solenoidal valve

% Extract variables from the state
xa = xx(1);  % Position [m]
va = xx(2);  % Velocity [m/s]

% Extract constants from the struct
ma = param.ACC.ma;
ka = param.ACC.ka;
ba = param.ACC.ba;
Msc = param.ACC.Msc;

% Initializzation
dxadt = zeros(2, 1);

% Computation of Drag
D = param.D.D(t);

% Computation of thrust
T = ionThruster(xv, param);

% Assemble ODEs
dxadt(1) = va;                                          % Velocity
dxadt(2) = ((T - D) * ma/Msc - ba * va - ka * xa)/ma;   % Acceleration

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:volatageModulation.m 
function [V_out_hat] = volatageModulation(va, param)
%-------------------------------------------------------------------------%
%                                                                         
% volatageModulation: function which for modulating volage, trough 
%                     Inverting operational amplifier
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [V_out_hat] = volatageModulation(va, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  va           [1]   accelerometer velocity                [m/s]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  V_out_hat    [1]   Volage                                [V]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  07/12/2024: First version
%
%-------------------------------------------------------------------------%

% Extract constants from the struct
Rin = param.AMP.Rin;
Rf = param.AMP.Rf;
Kacc = param.ACC.Kacc;

% Computation of input voltage
V_out = Kacc * va;

% Computation ofoutput voltage
V_out_hat = - Rf/Rin * V_out;

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:controlValveODE.m 
function [dxvdt] = controlValveODE(~, y, param)
%-------------------------------------------------------------------------%
%                                                                         
% controlValveODE: ODEs of the control valve
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dxvdt] = controlValveODE(~, xx, va, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [s]
%  y            [5x1] state                                 [m; m/s; m; m/s; A]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dydt         [3x1] ODE                                   [m/s; m/s2; A/s]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  07/12/2024: First version
%
%-------------------------------------------------------------------------%

% Extract state variables
xx = y(3:5);   % Position and velocity of accelerometer
va = y(2);     % Velocityof accelerometer

% Extract variables from the state
xv = xx(1);
vv = xx(2);
I = xx(3);

% Extract constants from the struct
mv = param.SOLV.mv;
kv = param.SOLV.kv;
bv = param.SOLV.bv;
Lxv = param.SOLV.L(xv);
dLdxv = param.SOLV.dLdxv(xv);

% Computation of modulated voltage
V_out_hat = volatageModulation(va, param);

% Initializzation
dxvdt = zeros(3, 1);

% Assemble ODEs
dxvdt(1) = vv;
dxvdt(2) = (-kv * xv - bv * vv + 1/2 * I^2 * dLdxv) / mv;
dxvdt(3) = 1/Lxv * V_out_hat;

% %if (xv <= 0 && vv < 0) || (xv >= param.SOLV.xv_max && vv > 0)
% if (xv <= 0) || (xv >= param.SOLV.xv_max)
%     dxvdt(1) = 0;
% else
%     dxvdt(1) = vv;
% end
end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:ionThruster.m 
function [T] = ionThruster(xv, param)
%-------------------------------------------------------------------------%
%                                                                         
% ionThruster: function used to comute the thrust by giving xv
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [T] = ionThruster(~, xv, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  xv           [1]   oprfice aperture                      [m]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  T            [1]   thrust                                [N]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  07/12/2024: First version
%
%-------------------------------------------------------------------------%

% Extract constants from the struct
k = param.THR.k;       % Heat ratio       [-]
pT = param.THR.pT;     % Tank pressure    [Pa]
TT = param.THR.TT;     % Tank temperature [K]
R = param.THR.R;       % Gas constants    [J/kg K]
q = param.THR.q;       % Charge           [C]
V = param.THR.V;       % Volatge          [V]
mi = param.THR.mi;     % Ion Mass         [kg]
Axv = param.THR.A(xv); % Orifice area     [m^2]

% Computation of the Xenon density 
rho_xe = pT / R / TT;

% Computation of the Xenon mass flow rate
mxe_dot = Axv * sqrt(k * rho_xe * pT * (2 / (k + 1))^((k + 1)/(k - 1)) ); 

% Computation of the Thrust
T = mxe_dot * sqrt(2 *q * V / mi);

end
%-------------------------------------------------------------------------%
