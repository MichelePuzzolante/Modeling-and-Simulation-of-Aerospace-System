% Modeling and Simulation of Aerospace Systems (2024/2025)
% Assignment # 2
% Author : Michele Puzzolante
%% EXERCISE 1
% Initializzation of the workspace
clear;
close all;
clc;

% Variable used for saving the plots
SAVEPLOTS = false;

% Set default options for plots
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');

fprintf('\n EXERCISE 1\n')

% Initializzation of the struct used to pass data to the functions
% S/C parameters
param.SC.h = 1.5;             % Height             [m]
param.SC.s = 0.5;             % Side               [m]
param.SC.SolarPanel_l = 0.95; % Solar panel length [m]
param.SC.SolarPanel_s = 0.5;  % Solar panel side   [m]
param.SC.SolarPanel_t = 0.01; % Solar panel thick  [m]

% THERMAL CONTROL MECHANIMS parameters
param.THCTR.R = 0.1;   % Resistance      [Ohm]
param.THCTR.L = 0.001; % Inductance      [H]
param.THCTR.km = 0.3;  % Mototr constant [Nm/A]
param.THCTR.mr = 0.2;  % Radiator mass   [kg]
param.THCTR.Lr = 0.5;  % Radiator length [m]
param.SC.Jr = 1/3 * param.THCTR.mr  * (param.THCTR.Lr^2);

% AREAS
% Area exopsed to the Sun
param.SC.ASun = [param.SC.s^2; param.SC.SolarPanel_l * param.SC.SolarPanel_s * ones(2, 1); 0; 0];
% Aerea exposed to the deeep space
param.SC.Ads =  [2*param.SC.s^2 + 2 * param.SC.s * param.SC.h + 2 * param.SC.s * (param.SC.h - param.SC.SolarPanel_t);...
                (param.SC.SolarPanel_l * param.SC.SolarPanel_s + 2 * param.SC.SolarPanel_l * param.SC.SolarPanel_t + param.SC.SolarPanel_t * param.SC.SolarPanel_s) * ones(2, 1);...
                 param.THCTR.Lr * param.SC.SolarPanel_s * ones(2, 1)];

% THERMAL SubSystem parameters
param.TH.PSun = 1350;                           % Sun power                                 [W/m^2]
param.TH.C = [1.5*1e5; 1187.5; 1187.5; 30; 30]; % Heat capacity of [BODY; SP; SP; RAD; RAD] [J/K]
% The thermal conductance has been definad has a matrix so it has been
% defined if a connection is present in this way is possible to construct
% the equation of conservation of energy iteratively without changing it, 0
% means that the two nodes are not connected, 1st row = 1st node and so on
param.TH.G = [0, 10, 10, 10, 10;
              10, 0, 0, 0, 0;
              10, 0, 0, 0, 0;
              10, 0, 0, 0, 0;
              10, 0, 0, 0, 0];                  % Thermal conductance                       [W/K]
param.TH.alpha = [0.6; 0.78; 0.78; 0; 0];       % Absorptitvity [BODY; SP; SP; RAD; RAD]    [-]
param.TH.emiss = [0.45; 0.75; 0.75; NaN; NaN];  % Emissivity [BODY; SP; SP; RAD; RAD]       [-]
param.TH.sigma = 5.67 * 10^-8;                  % STefan Boltzman constant                  [W/m^2/K^4]

% Emissivity law parameters
param.TH.emiss_min = 0.01;                % Minimum emissivity [-]
param.TH.emiss_max = 0.98;                % Maximum emissivity [-]
param.TH.theta_closed = -0.4*pi;          % Theta closed       [rad]
param.TH.theta0 = param.TH.theta_closed;  % Theta at t0        [rad]
param.TH.theta_min = -0.4 * pi;
param.TH.theta_max = 0;

% Emissivity law formulation [-]
param.TH.emiss_theta = @(theta) param.TH.emiss_min + (param.TH.emiss_max - param.TH.emiss_min)/(0.4 * pi) * (theta + 0.4 * pi);
 
% ENVIRONMENT
param.ENV.Tds = 3; % Deep space temperature [K]

% RANGES and T REF
param.TH.T_min = [290; NaN(4, 1)];     % Minimum T for each node   [K], NaN used for value not defined
param.TH.T_max = [300; NaN(4, 1)];     % Maximum T for each node   [K], NaN used for value not defined
param.TH.T0 = 298.15 * ones(5, 1);     % Initial T for each node   [K]
param.TH.T_ref = [294.15;  NaN(4, 1)]; % Reference T for each node [K], NaN used for value not defined
param.TH.t_osc = 10 * 60 * 60;         % Time at which chek maximum oscillations   [s]
param.TH.osc = 0.1/100;                % Maximum oscillations * T_ref for t_osc    [-]

% Computation of Kp
tau_el = param.THCTR.L/param.THCTR.R;
param.THCTR.kp = 1.2e-4;

% Initial conditions
yy0 = [param.TH.T0; 0; param.TH.theta0; 0];

% Time
t0 = 0;             % Initial time [s]
tf = 50 * 60 * 60;  % Final time   [s]

% Propagation of ODEs from t0 to tf
[tt, yy] = systemPropagation([t0 tf], yy0, param);

% Extract state variables
% Temperatures
T1 = yy(:, 1);
T2 = yy(:, 2);
T3 = yy(:, 3);
T4 = yy(:, 4);
T5 = yy(:, 5);

% Current
I = yy(:, 6) * 1e3;

% Extension mechanism
Theta = yy(:, 7);
ThetaDot = yy(:, 8) * 1e3;

% Time vector in hours
tt_h = tt/3600;

% Plot temperatures
figure(1)
plot(tt_h, T1, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
hold on
plot(tt_h, T2, 'LineWidth', 2)
plot(tt_h, T3, 'LineWidth', 2)
plot(tt_h, T4, 'LineWidth', 2)
plot(tt_h, T5, 'LineWidth', 2)
legend('$T_1$', '$T_2$', '$T_3$', '$T_4$', '$T_5$')
xlabel('Time [h]')
ylabel('Temperature [K]')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot T1 with bounds
figure(2)
yline(param.TH.T_max(1), 'LineWidth', 2,'LineStyle','--', 'Color', 'r', 'LabelVerticalAlignment','bottom', 'Label', 'T_{max} = 300', 'HandleVisibility','off')
hold on
yline(param.TH.T_min(1), 'LineWidth', 2,'LineStyle','--', 'Color', 'b', 'LabelVerticalAlignment','top', 'Label', 'T_{min} = 290', 'HandleVisibility','off')
yline(param.TH.T_ref(1), 'LineWidth', 1.7,'LineStyle','-', 'Color', 'm')
yline(param.TH.T_ref(1) * (1 + param.TH.osc), 'LineWidth', 1.2,'LineStyle','-.', 'Color', 'black')
yline(param.TH.T_ref(1) * (1 - param.TH.osc), 'LineWidth', 1.2,'LineStyle','-.', 'Color', 'black', 'HandleVisibility','off')
plot(tt_h, T1, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
legend('$T_{1,ref}$', '$(1\pm0.1\%)T_{1,ref}$','$T_1$', 'Location','northwest')
xlabel('Time [h]')
ylabel('Temperature [K]')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Zoom
axes('position',[0.5 0.55 0.3 0.3])
box on 
plot(tt_h, T1, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
hold on
yline(param.TH.T_ref(1), 'LineWidth', 1.7,'LineStyle','-', 'Color', 'm')
yline(param.TH.T_ref(1) * (1 + param.TH.osc), 'LineWidth', 1.2,'LineStyle','-.', 'Color', 'black')
yline(param.TH.T_ref(1) * (1 - param.TH.osc), 'LineWidth', 1.2,'LineStyle','-.', 'Color', 'black', 'HandleVisibility','off')
grid on
xlim([9 12])
ylim([293.5 295])

% Plot current
figure(3)
plot(tt_h, I, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
xlabel('Time [h]')
ylabel('Current [mA]')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Zoom
axes('position',[0.3 0.55 0.55 0.3])
box on 
plot(tt_h, I, 'LineWidth', 2, 'Color', [0.3010 0.7450 0.9330])
hold on
grid on
xlim([0 3])
ylim([-1e-5 1e-5])

% Plot theta
figure(4)
plot(tt_h, Theta, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
yline(param.TH.theta_min, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', '\theta_{min}=-0.4\pi', 'LabelVerticalAlignment','top')
yline(param.TH.theta_max, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', '\theta_{max}=0', 'LabelVerticalAlignment','bottom')
xlabel('Time [h]')
ylabel('$\theta$ [rad]')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Zoom
axes('position',[0.4 0.75 0.3 0.15])
box on 
plot(tt_h, Theta, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
grid on
xlim([0 2.5])
ylim([-0.1 0])
% Zoom
axes('position',[0.4 0.15 0.3 0.15])
box on 
plot(tt_h, Theta, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
grid on
xlim([2 3])
ylim([-0.4*pi -1])

% Plot theta_dot
figure(5)
plot(tt_h, ThetaDot, 'LineWidth', 2, 'Color', [0.4660 0.6740 0.1880])
xlabel('Time [h]')
ylabel('$\dot{\theta}$ [mrad/s]')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Zoom
axes('position',[0.3 0.35 0.55 0.5])
box on 
plot(tt_h, ThetaDot, 'LineWidth', 2, 'Color',  [0.4660 0.6740 0.1880])
hold on
grid on
xlim([0 3])
ylim([-5e-1 20e-1])

% Plot emissivity
figure(6)
plot(tt_h, param.TH.emiss_theta(Theta), 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980])
hold on
yline(0.01, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', '\epsilon_{min}=0.01', 'LabelVerticalAlignment','top')
yline(0.98, 'LineWidth', 1.5,'LineStyle','--', 'Color', 'black', 'Label', '\epsilon_{max}=0.98', 'LabelVerticalAlignment','bottom')
xlabel('Time [h]')
ylabel('$\epsilon$ [-]')
xlim([0 +Inf])
ylim([-Inf +Inf])


% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'T_evolution.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'T1.png','Resolution',600);

    % Saving 3rd figure
    figure(3)
    exportgraphics(gcf,'I.png','Resolution',600);

    % Saving 4th figure
    figure(4)
    exportgraphics(gcf,'theta.png','Resolution',600);

    % Saving 5th figure
    figure(5)
    exportgraphics(gcf,'theta_dot.png','Resolution',600);

    % Saving 6th figure
    figure(6)
    exportgraphics(gcf,'eps.png','Resolution',600);

end

%%  FUNCTIONS

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
%  yy0          [8x1] initial state                         [K; A; rad; rad/s]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  tt           [nx1] Time vector                           [s]
%  yy           [nx8] Solution                              [K; A; rad; rad/s]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  01/12/2024: First version
%
%-------------------------------------------------------------------------%

% Set tolerances
RelTol = 1e-6;
AbsTol_T = 1e-7 * ones(5, 1);
AbsTol_i = 1e-7;
AbsTol_theta = 1e-7 * ones(2, 1);

% Set options
options = odeset('reltol', RelTol, 'abstol', [AbsTol_T; AbsTol_i; AbsTol_theta]); 

% Perform integration
[tt, yy] = ode23s(@(t, y) systemDynamics(t, y, param), tspan, yy0, options);

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
%  y            [8x1] state                                 [K; A; rad; rad/s]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dydt         [8x1] ODE                                   [K/s; A/s; rad/s; rad/s2]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  01/12/2024: First version
%
%-------------------------------------------------------------------------%

% Conservation of energy
dTdt = energyConservation(t, y, param);

% Circuit
didt = circuitODE(t, y, param);

% Radiator dynamics
dthetadt = radiatorDynamics(t, y, param);

% Assemble the system of odes
dydt = [dTdt; didt; dthetadt];

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:energyConservation.m 
function [dTdt] = energyConservation(~, y, param)
%-------------------------------------------------------------------------%
%                                                                         
% energyConservation: ODEs of the thermal node
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dTdt] = energyConservation(~, T, theta, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [s]
%  y            [8x1] state                                 [K; A; rad; rad/s] 
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dTdt         [5x1] ODE                                   [K/s]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  01/12/2024: First version
%
%-------------------------------------------------------------------------%

% Extract state variables 
T = y(1:5);       % Nodes temperature [K]
theta = y(7);     % Theta             [rad]

% Exctract parameter from the struct
Tds = param.ENV.Tds;
sigma = param.TH.sigma;

% Get number of nodes
nNodes = 5;

% Initializzation of the ode vector
dTdt = zeros(nNodes, 1);
PSun = param.TH.PSun;

% Application of conservation of energy for each thermal node
for i = 1 : nNodes
    Q = 0;
    % Extract values from the stuct
    alpha = param.TH.alpha(i);
    ASun = param.SC.ASun(i);
    Ads = param.SC.Ads(i);
    C = param.TH.C(i);

    % Computation of power coming from sun
    Q = PSun * alpha * ASun;

    % Computation of conduction power
    for j = 1 : nNodes
        Gij = param.TH.G(i, j);
        Q = Q - Gij * (T(i) - T(j));
    end

    % Computation of power radiated to the deep space
    emiss = param.TH.emiss(i);

    % Check if the emissivity is NaN, so needs to be computeb in function
    % of theta
    if isnan(emiss)
        emiss_theta = param.TH.emiss_theta(theta);
        Q = Q - emiss_theta * sigma * Ads * (T(i)^4 - Tds^4);
    else
        Q = Q - emiss * sigma * Ads * (T(i)^4 - Tds^4);
    end
   
    dTdt(i) = (Q) / C;
end

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:circuitODE.m 
function [didt] = circuitODE(~, y, param)
%-------------------------------------------------------------------------%
%                                                                         
% circuitODE: ODEs of the circuit
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [didt] = circuitODE(~, y, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [s]
%  y            [8x1] state                                 [K; A; rad; rad/s]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  didt         [1] ODE                                     [A/s]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  01/12/2024: First version
%
%-------------------------------------------------------------------------%


% Extract state variables 
T = y(1:5);       % Nodes temperature [K]
i = y(6);         % Current           [A]
theta = y(7);     % Theta             [rad]
theta_dot = y(8); % theta dot         [rad/s]


% Extract parameter from the struct
kp = param.THCTR.kp;
R = param.THCTR.R;
L = param.THCTR.L;
T1_ref = param.TH.T_ref(1);
km = param.THCTR.km;

% Bound theta
if theta >= 0 && T(1)> T1_ref || theta <=-0.4*pi && T(1)<  T1_ref 

    V_in = 0;
else
    
    % Computation of the Voltage through the control law
    V_in = kp * (T(1) - T1_ref);
end

% Assemble the circuit ode
didt = (V_in - i * R - km * theta_dot) / L;

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:radiatorDynamics.m 
function [dthetadt] = radiatorDynamics(~, y, param)
%-------------------------------------------------------------------------%
%                                                                         
% radiatorDynamics: ODEs of radiator dynamics
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dthetadt] = radiatorDynamics(~, y, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [s]
%  y            [8x1] state                                 [K; A; rad; rad/s]  
%  param        [-]   struct with parameter of the problem  [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dthetadt     [2x1] ODE                                   [rad/s; rad/s2]  
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  01/12/2024: First version
%
%-------------------------------------------------------------------------%

% Extract state variables 
i = y(6);         % Current           [A]
theta_dot = y(8); % theta dot         [rad/s]

% Extract parameters from the struct
Jr = param.SC.Jr;
km = param.THCTR.km;

% Initializzation of odes
dthetadt = zeros(2, 1);

% Rotational radiator dynamics
dthetadt(1) = theta_dot;
tau_in = km * i;
dthetadt(2) = tau_in/Jr;

end
%-------------------------------------------------------------------------%