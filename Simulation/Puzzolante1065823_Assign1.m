% Modeling and Simulation of Aerospace Systems (2024/2025)
% Assignment # 1
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

% Initializzation of length
a1 = 10;    % [cm]
a2 = 13;    % [cm]
a3 = 8;     % [cm]
a4 = 10;    % [cm]
a = [a1; a2; a3; a4];

% Initializzation of a struct used for passing options to NewtonSolver
optionsNS.tol = 1e-5;                   % Tolerance
optionsNS.differenceType = 'centered';  % Type of difference to approximate the derivative
optionsNS.iter = false;                 % Flag to see the iterations
optionsNS.NMAXiter = 500;               % Maximum number of iterations
optionsNS.i = 0;                        % Initializzation of number of iterations

% Defnition of the Freudenstein function
Freudenstein = @(alpha, beta, a) a(1)/a(2) * cos(beta) - a(1)/a(4) * cos(alpha) - cos(beta - alpha) + (a(1)^2 + a(2)^2 - a(3)^2 + a(4)^2)/(2*a(2)*a(4));

% Defnition of the derivative of Freudenstein function w.r.t alpha
dFreudenstein_dalpha = @(alpha, beta, a) a(1)/a(4) * sin(alpha) - sin(beta - alpha);

% REQUEST 1 -> Implemetatntion of NewtonSolver.m

% REQUEST 2

% Initializzation of variables
N_points = 1200;                                  % Number of points for beta
beta_values = linspace(0, 2/3*pi, N_points);      % Values of beta
alpha_sol_NS_01_df   = zeros(N_points, 1);        % Vector for alpha computed using NS with to alpha0 = -0.1
alpha_sol_NS_23pi_df = zeros(N_points, 1);        % Vector for alpha computed using NS with to alpha0 = 2/3*pi
alpha_sol_fzero_01   = zeros(N_points, 1);        % Vector for alpha computed using fzero with to alpha0 = -0.1
alpha_sol_fzero_23pi = zeros(N_points, 1);        % Vector for alpha computed using fzero with to alpha0 = 2/3*pi
options_fzero = optimset();

% For used for computing the alpha
for i = 1 : N_points

    % NEWTON SOLVER alpha0 = -0.1
    [alpha_sol_NS_01_df(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_values(i), a), -0.1, optionsNS, @(alpha) dFreudenstein_dalpha(alpha, beta_values(i), a));

    % NEWTON SOLVER alpha0 = 2/3*pi
    [alpha_sol_NS_23pi_df(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_values(i), a), 2/3*pi, optionsNS,  @(alpha) dFreudenstein_dalpha(alpha, beta_values(i), a));

    % fzero alpha0 = -0.1
    alpha_sol_fzero_01(i) = fzero(@(alpha) Freudenstein(alpha, beta_values(i), a), -0.1, options_fzero);

    % fzero alpha0 = 2/3*pi
    alpha_sol_fzero_23pi(i) = fzero(@(alpha) Freudenstein(alpha, beta_values(i), a), 2/3*pi, options_fzero);
end

% Plot alpha computed with NS and fzero alpha0 = -0.1
figure(1)
plot(beta_values, alpha_sol_fzero_01, 'LineWidth', 2,  'Color', [0.4940 0.1840 0.5560])
% Plot alpha computed with NS and fzero alpha0 = 2/3*pi
hold on
plot(beta_values, alpha_sol_fzero_23pi, 'LineWidth', 2,  'Color', [0.9290 0.6940 0.1250])
hold off
xlabel('$\beta$ [rad]');  ylabel('$\alpha$ [rad]');
legend('$\alpha_0$ = -0.1', '$\alpha_0 = \frac{2}{3} \pi$', 'Location','northwest')
xlim([0 +Inf])

% Plot error between NS and fzero for alpha0 = -0.1 and alpha0 = 2/3*pi
figure(2)
semilogy(beta_values, abs(alpha_sol_NS_01_df - alpha_sol_fzero_01), 'LineWidth',2,  'Color', [0.4940 0.1840 0.5560], 'LineStyle','-', 'Marker','.')
hold on
semilogy(beta_values, abs(alpha_sol_NS_23pi_df - alpha_sol_fzero_23pi), 'LineWidth',2, 'Color', [0.9290 0.6940 0.1250], 'LineStyle','-', 'Marker','.')
hold off
xlabel('$\beta$ [rad]');  
ylabel('$|\alpha_{NS}$ - $\alpha_{fzero}|$ [rad]');
legend('$\alpha_0$ = -0.1', '$\alpha_0 = \frac{2}{3} \pi$', 'Location','southwest')
xlim([0 +Inf])

% REQUEST 3
alpha_sol_NS_01   = zeros(N_points, 1);     % Vector for alpha computed using NS with to alpha0 = -0.1
alpha_sol_NS_23pi = zeros(N_points, 1);     % Vector for alpha computed using NS with to alpha0 = 2/3*pi

% For used for computing the alpha
for i = 1 : N_points

    % NEWTON SOLVER beta0 = -0.1
    [alpha_sol_NS_01(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_values(i), a), -0.1, optionsNS);

    % NEWTON SOLVER beta0 = 2/3*pi
    [alpha_sol_NS_23pi(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_values(i), a), 2/3*pi, optionsNS);
end

% Plot error between NS with derivative and NS without derivative for alpha0 = -0.1 and alpha0 = 2/3*pi
figure(3)
semilogy(beta_values, abs(alpha_sol_NS_01 - alpha_sol_NS_01_df), 'LineWidth',2,   'Color', [0.4940 0.1840 0.5560], 'LineStyle','-', 'Marker','.')
hold on
semilogy(beta_values, abs(alpha_sol_NS_23pi - alpha_sol_NS_23pi_df), 'LineWidth',2, 'Color', [0.9290 0.6940 0.1250], 'LineStyle','-', 'Marker','.')
hold off
xlabel('$\beta$ [rad]');  
ylabel('$|\alpha_{NS, fin.diff.} - \alpha_{NS, an.derv}|$ [rad]');
legend('$\alpha_0$ = -0.1', '$\alpha_0 = \frac{2}{3} \pi$', 'Location','southwest')
xlim([0 +Inf])

% REQUEST 4
% INitializzation of variables
beta_exact = [0; pi/2];                                                % Values of beta
alpha_sol_NS_01_df_analitycal   = zeros(length(beta_exact), 1);        % Vector for alpha computed using NS with to alpha0 = -0.1
alpha_sol_NS_23pi_df_analitycal = zeros(length(beta_exact), 1);        % Vector for alpha computed using NS with to alpha0 = 2/3*pi
err_analytical_NS_01            = zeros(length(beta_exact), 1);        % Vector for error between NS and analytical with to alpha0 = -0.1
err_analytical_NS_23pi          = zeros(length(beta_exact), 1);        % Vector for error between NS and analytical with to alpha0 = 2/3pi       

% Analitycal solution for beta = 0 and pi/2
alpha_analytical_01 = [-acos(101/104); -acos(305/260/sqrt(2)) + pi/4];
alpha_analytical_23pi = [acos(101/104); acos(305/260/sqrt(2)) + pi/4];

for i = 1 : length(beta_exact)

    % NEWTON SOLVER alpha0 = -0.1
    [alpha_sol_NS_01_df_analitycal(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_exact(i), a), -0.1, optionsNS, @(alpha) dFreudenstein_dalpha(alpha, beta_exact(i), a));
    
    % NEWTON SOLVER alpha0 = 2/3*pi
    [alpha_sol_NS_23pi_df_analitycal(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_exact(i), a), 2/3*pi, optionsNS,  @(alpha) dFreudenstein_dalpha(alpha, beta_exact(i), a));
  

    % Computation of error between NS and exact solution
    err_analytical_NS_01(i) = abs(alpha_sol_NS_01_df_analitycal(i) - alpha_analytical_01(i));
    err_analytical_NS_23pi(i) = abs(alpha_sol_NS_23pi_df_analitycal(i) - alpha_analytical_23pi(i));

    % Display the results
    fprintf('\nThe error between the exact solution and the one \nwith NS for beta = %d and alpha0 = -0.1\n is %.4e[rad]\n', beta_exact(i), err_analytical_NS_01(i))
    fprintf('\nThe error between the exact solution and the one \nwith NS for beta = %d and alpha0 = 2/3pi\n is %.4e[rad]\n', beta_exact(i), err_analytical_NS_23pi(i))
    
end

% REQUEST 5
N_points_R5 = 3000;                                         % Number of points for beta
beta_values_R5          = linspace(0, pi, N_points_R5);     % Values of beta
alpha_sol_NS_01_df_R5   = zeros(N_points_R5, 1);            % Vector for alpha computed using NS with to alpha0 = -0.1
alpha_sol_NS_23pi_df_R5 = zeros(N_points_R5, 1);            % Vector for alpha computed using NS with to alpha0 = 2/3*pi
alpha_sol_fzero_01_R5   = zeros(N_points_R5, 1);            % Vector for alpha computed using fzero with to alpha0 = -0.1
alpha_sol_fzero_23pi_R5 = zeros(N_points_R5, 1);            % Vector for alpha computed using fzero with to alpha0 = 2/3*pi

% For used for computing the alpha
for i = 1 : N_points_R5

    % NEWTON SOLVER beta0 = -0.1
    [alpha_sol_NS_01_df_R5(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_values_R5(i), a), -0.1, optionsNS, @(alpha) dFreudenstein_dalpha(alpha, beta_values_R5(i), a));

    % NEWTON SOLVER beta0 = 2/3*pi
    [alpha_sol_NS_23pi_df_R5(i), ~, ~] = NewtonSolver(@(alpha) Freudenstein(alpha, beta_values_R5(i), a), 2/3*pi, optionsNS,  @(alpha) dFreudenstein_dalpha(alpha, beta_values_R5(i), a));

    % fzero beta0 = -0.1
    alpha_sol_fzero_01_R5(i) = fzero(@(alpha) Freudenstein(alpha, beta_values_R5(i), a), -0.1, options_fzero);

    % fzero beta0 = 2/3*pi
    alpha_sol_fzero_23pi_R5(i) = fzero(@(alpha) Freudenstein(alpha, beta_values_R5(i), a), 2/3*pi, options_fzero);
end

% Computation of the errors
err_alpha_01_R5 = abs(alpha_sol_NS_01_df_R5 - alpha_sol_fzero_01_R5);
err_alpha_23pi_R5 = abs(alpha_sol_NS_23pi_df_R5 - alpha_sol_fzero_23pi_R5);
iLim = min(sum(err_alpha_01_R5<1e-0), sum(err_alpha_23pi_R5<1e-0));

% Plot alpha computed with  with derivative and NS without derivative alpha0 = -0.1
figure(4)
plot(beta_values_R5, alpha_sol_fzero_01_R5, 'LineWidth', 2,  'Color', [0.4940 0.1840 0.5560])
% Plot alpha computed with  with derivative and NS without derivative alpha0 =
% 2/3*pi
hold on
plot(beta_values_R5, alpha_sol_fzero_23pi_R5, 'LineWidth', 2,  'Color', [0.9290 0.6940 0.1250])
hold off
xlabel('$\beta$ [rad]');  
ylabel('$\alpha$ [rad]');
legend('$\alpha_0$ = -0.1', '$\alpha_0 = \frac{2}{3} \pi$', 'Location','northwest')
xlim([0 +Inf])
ylim([min(min(alpha_sol_fzero_23pi_R5), min(alpha_sol_fzero_01_R5)) max(max(alpha_sol_fzero_23pi_R5), max(alpha_sol_fzero_01_R5))])
% Creation of zoom inside the plot
axes('position',[0.175 0.16 0.6 0.45])
box on 
plot(beta_values_R5(1:iLim), alpha_sol_fzero_01_R5(1:iLim), 'LineWidth', 2,  'Color', [0.4940 0.1840 0.5560])
hold on
plot(beta_values_R5(1:iLim), alpha_sol_fzero_23pi_R5(1:iLim), 'LineWidth', 2,  'Color', [0.9290 0.6940 0.1250])
% Plot the stability domain for IEX4
axis tight

% error between NS and fzero for alpha0 = -0.1 and alpha0 = 2/3*pi
figure(5)
semilogy(beta_values_R5, err_alpha_01_R5, 'LineWidth',2,  'Color', [0.4940 0.1840 0.5560], 'LineStyle','-', 'Marker','.')
hold on
semilogy(beta_values_R5, err_alpha_23pi_R5, 'LineWidth',2, 'Color', [0.9290 0.6940 0.1250], 'LineStyle','-', 'Marker','.')
hold off
legend('$\alpha_0$ = -0.1', '$\alpha_0 = \frac{2}{3} \pi$', 'Location','northwest')
xlabel('$\beta$ [rad]');  
ylabel('$|\alpha_{NS}$ - $\alpha_{fzero}|$ [rad]');
xlim([0 +Inf])

% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'NS_vs_fzero_analyticalderivative.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'NS_vs_fzero_error_analyticalderivative.png','Resolution',600);

    % Saving 3rd figure
    figure(3)
    exportgraphics(gcf,'NS_vs_NS_error_finitediff.png','Resolution',600);

    % Saving 4th figure
    figure(4)
    exportgraphics(gcf,'NS_vs_fzero_R5.png','Resolution',600);

    % Saving 5th figure
    figure(5)
    exportgraphics(gcf,'NS_vs_fzero_R5_error.png','Resolution',600);

end

%% EXERCISE 2
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

fprintf('\n EXERCISE 2\n')

% Initializzation of the struct used to pass values to the ODE
param_EX2.v0 = 0;       % Initial velocity [m/s]
param_EX2.m0 = 20;      % Initial mass     [kg]
param_EX2.cm = 0.1;     %                  [kg/s]
param_EX2.f = 1;        % Force            [N]
param_EX2.alpha = 0.01; %                  [Nm/s]
param_EX2.rho = 0;      % Density          [kg/m^3]
param_EX2.Cd = 0;       % Drag coeff.      [-]
param_EX2.Am = 0;       % Area             [m^2]

% Initializzation of the initial and final time
t0 = 0;             % Initial time     [s]
tf = 160;           % Final time       [s]
v0 = param_EX2.v0;  % Initial velocity [m/s]

% Defnition of the exact solution
v_exact = @(t, param) param.f/param.alpha - (param.f/param.alpha - param.v0) * (1 - param.cm * t/ param.m0).^(param.alpha/param.cm); 

% REQUEST 1

% Initializzation of the beta matrix and alpha vector used for RK2 
alpha_Heun = [1; 1];
beta_Heun  = [1 0; 1/2 1/2];

% REQUEST 2

% Definition of the different values for the time step
h1 = 50; % [s]
h2 = 20; % [s]
h3 = 10; % [s]
h4 = 1;  % [s]

% Call RK2
[v_rk2_h1, t_rk2_h1] = RungeKutta(@ODE_EX2, v0, t0, tf, h1, alpha_Heun, beta_Heun, param_EX2); % Call RK2 with time step equal to h1
[v_rk2_h2, t_rk2_h2] = RungeKutta(@ODE_EX2, v0, t0, tf, h2, alpha_Heun, beta_Heun, param_EX2); % Call RK2 with time step equal to h2
[v_rk2_h3, t_rk2_h3] = RungeKutta(@ODE_EX2, v0, t0, tf, h3, alpha_Heun, beta_Heun, param_EX2); % Call RK2 with time step equal to h3
[v_rk2_h4, t_rk2_h4] = RungeKutta(@ODE_EX2, v0, t0, tf, h4, alpha_Heun, beta_Heun, param_EX2); % Call RK2 with time step equal to h4

% Computation of the error between the exact solution and the ones obained
% with RK2
err_RK2_exact_h1 = abs(v_rk2_h1 - v_exact(t_rk2_h1, param_EX2)); % Error between analytic solution and RK2 solution for h1
err_RK2_exact_h2 = abs(v_rk2_h2 - v_exact(t_rk2_h2, param_EX2)); % Error between analytic solution and RK2 solution for h2
err_RK2_exact_h3 = abs(v_rk2_h3 - v_exact(t_rk2_h3, param_EX2)); % Error between analytic solution and RK2 solution for h3
err_RK2_exact_h4 = abs(v_rk2_h4 - v_exact(t_rk2_h4, param_EX2)); % Error between analytic solution and RK2 solution for h4

% Plot velocities
figure(1)
% RK2 h1
subplot(2, 2, 1)
plot(t_rk2_h1, v_rk2_h1, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk2_h1, v_exact(t_rk2_h1, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK2 with $h_1$ = 50s');      legend('$v_{RK2}$', '$v_{EX}$', 'Location','best', 'FontSize', 15)
% RK2 h2
subplot(2, 2, 2)
plot(t_rk2_h2, v_rk2_h2, 'LineWidth', 2,  'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk2_h2, v_exact(t_rk2_h2, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK2 with $h_2$ = 20s'); legend('$v_{RK2}$', '$v_{EX}$', 'Location','best', 'FontSize', 15);
% RK2 h3
subplot(2, 2, 3)
plot(t_rk2_h3, v_rk2_h3, 'LineWidth', 2,  'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk2_h3, v_exact(t_rk2_h3, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK2 with $h_3$ = 10s'); legend('$v_{RK2}$', '$v_{EX}$', 'Location','best', 'FontSize', 15);
% RK2 h4
subplot(2, 2, 4)
plot(t_rk2_h4, v_rk2_h4, 'LineWidth', 2,  'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk2_h4, v_exact(t_rk2_h4, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK2 with $h_4$ = 1s'); legend('$v_{RK2}$', '$v_{EX}$', 'Location','best', 'FontSize', 15);

% Plot of the error for RK2
figure(2)
semilogy(t_rk2_h1, err_RK2_exact_h1, 'LineWidth', 2, 'Color', [0 0.4470 0.7410])
hold on
semilogy(t_rk2_h2, err_RK2_exact_h2, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
semilogy(t_rk2_h3, err_RK2_exact_h3, 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250])
semilogy(t_rk2_h4, err_RK2_exact_h4, 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold off
xlabel('Time [s]', 'FontSize', 15)
ylabel('Heuns''s method integration error', 'FontSize', 15)
legend('$h_1$ = 50', '$h_2$ = 20', '$h_3$ = 10', '$h_4$ = 1', 'Location','best', 'FontSize', 15)

% REQUEST 3

% Initializzation of the beta matrix and alpha vector used for RK4 
alpha_RK4 = [1/2; 1/2; 1; 1];
beta_RK4  = [1/2 0 0 0; 0 1/2 0 0; 0 0 1 0; 1/6 1/3 1/3 1/6];

% Call RK4
[v_rk4_h1, t_rk4_h1] = RungeKutta(@ODE_EX2, v0, t0, tf, h1, alpha_RK4, beta_RK4, param_EX2); % Call RK4 with time step equal to h1
[v_rk4_h2, t_rk4_h2] = RungeKutta(@ODE_EX2, v0, t0, tf, h2, alpha_RK4, beta_RK4, param_EX2); % Call RK4 with time step equal to h2
[v_rk4_h3, t_rk4_h3] = RungeKutta(@ODE_EX2, v0, t0, tf, h3, alpha_RK4, beta_RK4, param_EX2); % Call RK4 with time step equal to h3
[v_rk4_h4, t_rk4_h4] = RungeKutta(@ODE_EX2, v0, t0, tf, h4, alpha_RK4, beta_RK4, param_EX2); % Call RK4 with time step equal to h4

% Computation of the error between the exact solution and the ones obained
% with RK4
err_RK4_exact_h1 = abs(v_rk4_h1 - v_exact(t_rk4_h1, param_EX2)); % Error between analytic solution and RK4 solution for h1
err_RK4_exact_h2 = abs(v_rk4_h2 - v_exact(t_rk4_h2, param_EX2)); % Error between analytic solution and RK4 solution for h2
err_RK4_exact_h3 = abs(v_rk4_h3 - v_exact(t_rk4_h3, param_EX2)); % Error between analytic solution and RK4 solution for h3
err_RK4_exact_h4 = abs(v_rk4_h4 - v_exact(t_rk4_h4, param_EX2)); % Error between analytic solution and RK4 solution for h4

% Plot velocities
figure(3)
% RK4 h1
subplot(2, 2, 1)
plot(t_rk4_h1, v_rk4_h1, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk4_h1, v_exact(t_rk4_h1, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK4 with $h_1$ = 50s');      legend('$v_{RK4}$', '$v_{EX}$', 'Location','best', 'FontSize', 15)
% RK4 h2
subplot(2, 2, 2)
plot(t_rk4_h2, v_rk4_h2, 'LineWidth', 2,  'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk4_h2, v_exact(t_rk4_h2, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK4 with $h_2$ = 20s'); legend('$v_{RK4}$', '$v_{EX}$', 'Location','best', 'FontSize', 15);
% RK4 h3
subplot(2, 2, 3)
plot(t_rk4_h3, v_rk4_h3, 'LineWidth', 2,  'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk4_h3, v_exact(t_rk4_h3, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK4 with $h_3$ = 10s'); legend('$v_{RK4}$', '$v_{EX}$', 'Location','best', 'FontSize', 15);
% RK4 h4
subplot(2, 2, 4)
plot(t_rk4_h4, v_rk4_h4, 'LineWidth', 2,  'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk4_h4, v_exact(t_rk4_h4, param_EX2), 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK4 with $h_4$ = 1s'); legend('$v_{RK4}$', '$v_{EX}$', 'Location','best', 'FontSize', 15);

% Plot the error for RK4
figure(4) 
semilogy(t_rk4_h1, err_RK4_exact_h1, 'LineWidth', 2, 'Color', [0 0.4470 0.7410])
hold on
semilogy(t_rk4_h2, err_RK4_exact_h2, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
semilogy(t_rk4_h3, err_RK4_exact_h3, 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250])
semilogy(t_rk4_h4, err_RK4_exact_h4, 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold off
xlabel('Time [s]', 'FontSize', 15)
ylabel('RK4 integration error', 'FontSize', 15)
legend('$h_1$ = 50', '$h_2$ = 20', '$h_3$ = 10', '$h_4$ = 1', 'Location','northwest', 'FontSize', 15)

% REQUEST 4

% Computation of CPU time

% RK2 with time step equal to h1
CPU_time_RK2_h1 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h1, alpha_Heun, beta_Heun, param_EX2), 2); 

% RK2 with time step equal to h2
CPU_time_RK2_h2 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h2, alpha_Heun, beta_Heun, param_EX2), 2);

% RK2 with time step equal to h3
CPU_time_RK2_h3 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h3, alpha_Heun, beta_Heun, param_EX2), 2);

% RK2 with time step equal to h4
CPU_time_RK2_h4 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h4, alpha_Heun, beta_Heun, param_EX2), 2);

% RK4 with time step equal to h1
CPU_time_RK4_h1 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h1, alpha_RK4, beta_RK4, param_EX2), 2);

% RK4 with time step equal to h2
CPU_time_RK4_h2 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h2, alpha_RK4, beta_RK4, param_EX2), 2);

% RK4 with time step equal to h3
CPU_time_RK4_h3 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h3, alpha_RK4, beta_RK4, param_EX2), 2);

% RK4 with time step equal to h4
CPU_time_RK4_h4 = timeit(@() RungeKutta(@ODE_EX2, v0, t0, tf, h4, alpha_RK4, beta_RK4, param_EX2), 2);


% Plot CPU time vs error for RK2 and RK4 for all h
figure(5)
loglog(CPU_time_RK2_h1, max(err_RK2_exact_h1), 'LineStyle', 'none', 'Marker','+', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0 0.4470 0.7410]) 
hold on
loglog(CPU_time_RK2_h2, max(err_RK2_exact_h2), 'LineStyle', 'none', 'Marker','+', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0.6350 0.0780 0.1840]) 
loglog(CPU_time_RK2_h3, max(err_RK2_exact_h3), 'LineStyle', 'none', 'Marker','+', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0.9290 0.6940 0.1250]) 
loglog(CPU_time_RK2_h4, max(err_RK2_exact_h4), 'LineStyle', 'none', 'Marker','+', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0.4940 0.1840 0.5560])
loglog(CPU_time_RK4_h1, max(err_RK4_exact_h1), 'LineStyle', 'none', 'Marker','o', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0 0.4470 0.7410]) 
loglog(CPU_time_RK4_h2, max(err_RK4_exact_h2), 'LineStyle', 'none', 'Marker','o', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0.6350 0.0780 0.1840]) 
loglog(CPU_time_RK4_h3, max(err_RK4_exact_h3), 'LineStyle', 'none', 'Marker','o', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0.9290 0.6940 0.1250]) 
loglog(CPU_time_RK4_h4, max(err_RK4_exact_h4), 'LineStyle', 'none', 'Marker','o', 'LineWidth',2, 'MarkerSize', 10, 'Color', [0.4940 0.1840 0.5560])
hold off
xlabel('CPU Time [s]', 'FontSize', 15)
ylabel('Error', 'FontSize', 15)
legend('RK2 $h_1$ = 50', 'RK2 $h_2$ = 20', 'RK2 $h_3$ = 10', 'RK2 $h_4$ = 1',...
       'RK4 $h_1$ = 50', 'RK4 $h_2$ = 20', 'RK4 $h_3$ = 10', 'RK4 $h_4$ = 1','Location','southwest', 'FontSize', 12)

% REQUEST 5

% Initializzation of the new parameters for the problem
param_EX2.rho = 900;  % Density    [kg/m^3]
param_EX2.Cd = 2.05;  % Drag coeff.[-]
param_EX2.Am = 1;     % Area       [m^2]
h_R5 = 1;             % Time step  [s]

% Call RK2 
[v_rk2_heun_h1_R5, t_rk2_heun_h_R5] = RungeKutta(@ODE_EX2, v0, t0, tf, h_R5, alpha_Heun, beta_Heun, param_EX2);

% Call odesolver
[t_ode15s, ~] = ode15s(@(t, v) ODE_EX2(t, v, param_EX2), [t0 tf], v0);
[t_ode23, ~] = ode23(@(t, v) ODE_EX2(t, v, param_EX2), [t0 tf], v0);
[t_ode23s, ~] = ode23s(@(t, v) ODE_EX2(t, v, param_EX2), [t0 tf], v0);
[~, v_ode23sMATLAB] = ode23s(@(t, v) ODE_EX2(t, v, param_EX2), t_rk2_heun_h_R5, v0);

% Compute error between the RK2 and ode w.r.t. the exact solution
err_RK2_R5 = abs(v_rk2_heun_h1_R5 - v_ode23sMATLAB');

% h_max
v_eq = fzero(@(v) -param_EX2.rho * param_EX2.Cd * param_EX2.Am * 0.5 * v^2 + param_EX2.f - param_EX2.alpha*v, 0.2);
F_lin = - param_EX2.rho * param_EX2.Cd * param_EX2.Am * v_eq ;
lamda = (-param_EX2.alpha + F_lin) /4;
h_max = -2/lamda;
fprintf('\n The maximum h for RK2 is %.4f', h_max)

% Plot the error
figure(6)
semilogy(t_rk2_heun_h_R5, err_RK2_R5, 'LineWidth', 2, 'Color', [0 0.4470 0.7410])
hold on
xlabel('Time [s]', 'FontSize', 15)
ylabel('Error', 'FontSize', 15)

% Plot velocities
figure(7)
% RK4 h1
plot(t_rk2_heun_h_R5, v_rk2_heun_h1_R5, 'LineWidth', 2, 'Color', [0.6350 0.0780 0.1840])
hold on
plot(t_rk2_heun_h_R5, v_ode23sMATLAB, 'LineWidth', 2,  'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15); ylabel('v [m/s]', 'FontSize', 15);
title('RK2 with $h$ = 1s');      
legend('v$_{RK2}$', 'v$_{ode23s}$', 'Location','best', 'FontSize', 15)

% Save plots
if SAVEPLOTS

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'err_RK2.png','Resolution',600);

    % Saving 4th figure
    figure(4)
    exportgraphics(gcf,'err_RK4.png','Resolution',600);

    % Saving 5th figure
    figure(5)
    exportgraphics(gcf,'CPU_vs_err.png','Resolution',600);

    % Saving 6th figure
    figure(6)
    exportgraphics(gcf,'err_exactc_v.png','Resolution',600);

end

%% EXERCISE 3
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

fprintf('\n EXERCISE 3\n')

%---------------------------------POINT a---------------------------------%

% REQUEST 1

% Initializzation of matrix A
A = @(alpha) [0 1; -1 2*cos(alpha)];

% Operators which maps xk into xk+1 for RK2
FRK2 = @(h, alpha) eye(2) +  h * A(alpha) + 1/2 * h^2 * A(alpha) * A(alpha);

% REQUEST 3

% Get the h for alpha = pi
[h_RK2_pi, ~] = stabilityDomain(FRK2, pi, 2);

% Initializzation of variables
nPoints = 500;                          % Number of points for alpha between 0 and pi
alpha_vec = linspace(pi, 0, nPoints);   % Alpha which contains the values of alpha

% Get the h and eigenvalues for FRK2
[h_RK2, lambda] = stabilityDomain(FRK2, alpha_vec, h_RK2_pi);

% Plot the stability domain for RK2
figure(1)
hold on
plot(real(diag(h_RK2*lambda(1,:))), imag(diag(h_RK2*lambda(1,:))), 'LineWidth',2, 'Color',[0.6350 0.0780 0.1840], 'LineStyle','-');
plot(real(diag(h_RK2*lambda(2,:))), imag(diag(h_RK2*lambda(2,:))), 'LineWidth',2, 'Color',[0.6350 0.0780 0.1840], 'LineStyle','-', 'HandleVisibility','off');
xlabel('Re\{h$\lambda$\}', 'FontSize',12);
ylabel('Im\{h$\lambda$\}', 'FontSize',12);

% REQUEST 4

% Operators which maps xk into xk+1 for RK4
FRK4 = @(h, alpha) eye(2) + ...
                    1 * h * A(alpha) + ...
                    1/2 * h^2 * A(alpha) * A(alpha) + ...
                    1/6 * h^3  * A(alpha) * A(alpha) * A(alpha) + ...
                    1/24 * h^4 * A(alpha) * A(alpha) * A(alpha) * A(alpha);

% Get the h for alpha = pi
[h_RK4_pi, ~] = stabilityDomain(FRK4, pi, 2.8);

% Get the h and eigenvalues for FRK4
[h_RK4, lambda] = stabilityDomain(FRK4, alpha_vec, h_RK4_pi);

% Plot stability domain for RK4
figure(1)
hold on
plot(real(diag(h_RK4*lambda(1,:))), imag(diag(h_RK4*lambda(1,:))), 'LineWidth',2, 'Color',[0.9290 0.6940 0.1250], 'LineStyle','-');
plot(real(diag(h_RK4*lambda(2,:))), imag(diag(h_RK4*lambda(2,:))), 'LineWidth',2, 'Color',[0.9290 0.6940 0.1250], 'LineStyle','-');
xlabel('Re\{h$\lambda$\}', 'FontSize', 12);
ylabel('Im\{h$\lambda$\}', 'FontSize', 12);
legend('RK2', 'RK4', 'Location', 'northwest')

%---------------------------------POINT b---------------------------------%

% Operators which maps xk into xk+1 for BI2
BBI2theta = @(h, alpha, theta) (eye(2) - (1 - theta) * h * A(alpha) + 0.5*((1- theta)*h)^2 * A(alpha) * A(alpha)) \ (eye(2) + theta * h * A(alpha) + 0.5*(theta * h)^2 * A(alpha) * A(alpha)) ;

% Initializzation of variables
theta_vec = [0.2 0.3 0.4 0.6 0.8];      % Values of theta
h0_vec = [3, 5, 10, 10, 3];          % Initial guess for h
h_BI2_pi = zeros(length(theta_vec), 1); % Vector use for saving the value of h at alpha = pi
h_BI2 = zeros(length(alpha_vec), 5);    % Maxtrix for h values for every value of theta in theta_vec
ColorsBI = [[0.3010 0.7450 0.9330];...  % Matrix used for colors in plot
            [0.8500 0.3250 0.0980];...
            [0.4660 0.6740 0.1880];...
            [0.9290 0.6940 0.1250];...
            [0.6350 0.0780 0.1840]];

% Open figure for plotting the stability domains 
figure(2)
hold on

% For changing theta
for j = 1 : length(theta_vec)
    
    % Initializzation of alpha_vec depending on theta
    if theta_vec(j) > 0.5

        % Alpha which contains the values of alpha
        alpha_vec = linspace(pi, 0, nPoints);   
    else
        % Alpha which contains the values of alpha
        alpha_vec = linspace(0, pi, nPoints); 
    end

    % Get the h for alpha = pi
    [h_BI2_pi(j), ~] = stabilityDomain(@(h, alpha) BBI2theta(h, alpha, theta_vec(j)), alpha_vec(1), h0_vec(j));

    % Get the h and eigenvalues for BI2_theta_j
    [h_BI2(:, j), lambda] = stabilityDomain(@(h, alpha) BBI2theta(h, alpha, theta_vec(j)), alpha_vec, h_BI2_pi(j));
    
    % Plot the stability domain
    plot(real(diag(h_BI2(:, j)*lambda(1,:))), imag(diag(h_BI2(:, j)*lambda(1,:))), 'LineWidth',2, 'Color',ColorsBI(j, :), 'LineStyle','-', 'HandleVisibility', 'on');
    plot(real(diag(h_BI2(:, j)*lambda(2,:))), imag(diag(h_BI2(:, j)*lambda(2,:))), 'LineWidth',2, 'Color',ColorsBI(j, :), 'LineStyle','-', 'HandleVisibility', 'off');
end

xlabel('Re\{h$\lambda$\}', 'FontSize', 12);
ylabel('Im\{h$\lambda$\}', 'FontSize', 12);
legend('$\theta$ = 0.2', '$\theta$ = 0.3', '$\theta$ = 0.4', '$\theta$ = 0.6', '$\theta$ = 0.8', 'FontSize', 12, 'Location', 'bestoutside');

% Display the results
fprintf('\nFor RK2, for alpha = pi, h = %.4f', h_RK2_pi)
fprintf('\nFor RK4, for alpha = pi, h = %.4f', h_RK4_pi)

% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'RK2_RK4_stabreg.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'theta_stabreg.png','Resolution',600);

end

%% EXERCISE 4
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

fprintf('\n EXERCISE 4\n')

% Initializzation of the struct used to pass values to the ODE
param_EX4.Kc = 0.0042;        % Convective coefficient [J/(s K)]
param_EX4.Kr = 6.15 * 10^-11; % Radiative coefficient  [J/(s K^4)]
param_EX4.Ta = 277;           % Surroind air temp.     [K]
param_EX4.C = 45;             % Mass thermal capacity  [J/K]

T0 = 555;       % Initial mass temperature [K]
t0 = 0;         % Initial time             [s]
tf = 1440 * 20; % Final time               [s]

% REQUEST 1 -> ODE_EX4

% REQUEST 2

% Initializzation of the parameters for Runge-Kutta 2
alpha_RK2 = [1; 1];
beta_RK2  = [1 0; 1/2 1/2];
h_RK2     = 720;            % Time step [s]

% Initializzation of the parameters for Runge-Kutta 4
alpha_RK4 = [1/2; 1/2; 1; 1];
beta_RK4  = [1/2 0 0 0; 0 1/2 0 0; 0 0 1 0; 1/6 1/3 1/3 1/6];
h_RK4     = 1440;           % Time step [s]

% Perform integration
[T_RK2, t_RK2] = RungeKutta(@ODE_EX4, T0, t0, tf, h_RK2, alpha_RK2, beta_RK2, param_EX4); % Call RK2
[T_RK4, t_RK4] = RungeKutta(@ODE_EX4, T0, t0, tf, h_RK4, alpha_RK4, beta_RK4, param_EX4); % Call RK4

% Call ode matlab to compare the solutions
[t_hRK2, T_hRK2_odeMATLAB] = ode45(@(t, T) ODE_EX4(t, T, param_EX4), t_RK2, T0); % tspan equal to RK2
[t_hRK4, T_hRK4_odeMATLAB] = ode45(@(t, T) ODE_EX4(t, T, param_EX4), t_RK4, T0); % tspan equal to RK4

% Computation of the erro between RK and MATLAB ode
err_RK2_odeMATLAB = abs(T_RK2' - T_hRK2_odeMATLAB); % Compute the error between RK2 and ode solver matlab
err_RK4_odeMATLAB = abs(T_RK4' - T_hRK4_odeMATLAB); % Compute the error between RK4 and ode solver matlab

% Plot the error
figure(1)
semilogy(t_RK2, err_RK2_odeMATLAB, 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold on
semilogy(t_RK4, err_RK4_odeMATLAB, 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250])
hold off
xlabel('Time [s]', 'FontSize', 15);
ylabel('$|$RK - ode45$|$', 'FontSize', 15);
legend('RK2', 'RK4', 'FontSize', 15)
xlim([0 +Inf])

% Plot the temperature against time
figure(2)
plot(t_RK2, T_RK2,'Linewidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold on
plot(t_hRK2, T_hRK2_odeMATLAB,'Linewidth', 2,'Color', [0.3010 0.7450 0.9330])
yline(param_EX4.Ta, 'LineWidth',1.5, 'Color','black', 'LineStyle','--')
hold off
xlabel('Time [s]', 'FontSize', 15);
ylabel('T [K]', 'FontSize', 15);
legend('RK2', 'ode45','$T_a$', 'FontSize', 15)
xlim([0 +Inf])

% Plot the temperature against time
figure(3)
plot(t_RK4, T_RK4,'Linewidth', 2,'Color',[0.9290 0.6940 0.1250])
hold on
plot(t_hRK4, T_hRK4_odeMATLAB,'Linewidth', 2, 'Color', [0.3010 0.7450 0.9330])
yline(param_EX4.Ta, 'LineWidth',1.5, 'Color','black', 'LineStyle','--')
hold off
xlabel('Time [s]', 'FontSize', 15);
ylabel('T [K]', 'FontSize', 15);
legend('RK4', 'ode45','$T_a$', 'FontSize', 15)
xlim([0 +Inf])

% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'err_RK2_RK4.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'RK2_solT.png','Resolution',600);

    % Saving 3rd figure
    figure(3)
    exportgraphics(gcf,'RK4_solT.png','Resolution',600);

end

%% EXERCISE 5
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

fprintf('\n EXERCISE 5\n')

% Initializzation of the struct used to pass values to the ODE
param_EX5.R = 25;       % Resistance [Ohm]
param_EX5.L = 20*1e-3;  % Inductance [H]
param_EX5.C = 200*1e-3; % Conductance[F]
param_EX5.V0 = 12;       % Voltage    [V]

% Initializzation of variables
nPoints = 500;                          % Number of points for alpha between 0 and pi

% REQUEST 1

% Matrix for the state variable form
A_State = [0, 1; -1/param_EX5.L/param_EX5.C, -param_EX5.R/param_EX5.L];

% REQUEST 2

% Computation of the eigenvalues of A
eigeinvalues = eig(A_State);

% Initializzation of matrix A
A = @(alpha) [0 1; -1 2*cos(alpha)];

% Operators which maps xk into xk+1 for RK2
FRK2 = @(h, alpha) eye(2) +  h * A(alpha) + 1/2 * h^2 * A(alpha) * A(alpha);

% Operators which maps xk into xk+1 for IEX4
FIEX4 = @(h, alpha) -1/6 * (eye(2) - h * A(alpha))^(-1)...
                     + 4 * (eye(2) - h/2 * A(alpha))^(-2)...
                  - 27/2 * (eye(2) - h/3 * A(alpha))^(-3)...
                  + 32/3 * (eye(2) - h/4 * A(alpha))^(-4);

% Get the h and eigenvalues for FRK2
[h_RK2, lambda_RK2] = stabilityDomain(FRK2, linspace(pi, 0, nPoints), 2);

% Get the h and eigenvalues for FRK2
[h_IEX4, lambda_IEX4] = stabilityDomain(FIEX4, linspace(0, pi, nPoints), 12.5);

% Computation of the maximum stepsize to obtain an accurate solution with
% RK2
h_MAX_RK2 = h_RK2(1)/max(abs(eigeinvalues));

% Display the result
fprintf('\nLambda1 = %.4f\tLambda2 = %.4f', eigeinvalues(1), eigeinvalues(2))
fprintf('\nTau1 = %.4f\tTau2 = %.4f', -1/eigeinvalues(1), -1/eigeinvalues(2))
fprintf('\nThe maximum h to obtain an accurate solution with RK2 is %.8f', h_MAX_RK2);

% Plot the stability domain for RK2
figure(1)
hold on
plot(real(diag(h_RK2*lambda_RK2(1,:))), imag(diag(h_RK2*lambda_RK2(1,:))), 'Color',[0.6350 0.0780 0.1840], 'LineStyle','-', 'LineWidth', 2);
plot(real(diag(h_RK2*lambda_RK2(2,:))), imag(diag(h_RK2*lambda_RK2(2,:))), 'Color',[0.6350 0.0780 0.1840], 'LineStyle','-', 'LineWidth', 2, 'HandleVisibility','off');

% Plot the stability domain for IEX4
figure(1)
plot(real(diag(h_IEX4*lambda_IEX4(1,:))), imag(diag(h_IEX4*lambda_IEX4(1,:))), 'Color',[0.3010 0.7450 0.9330], 'LineStyle','-', 'LineWidth', 2);
plot(real(diag(h_IEX4*lambda_IEX4(2,:))), imag(diag(h_IEX4*lambda_IEX4(2,:))), 'Color',[0.3010 0.7450 0.9330], 'LineStyle','-', 'LineWidth', 2, 'HandleVisibility','off');

% Plot the eigenvalues of the system
figure(1)
plot(real(eigeinvalues(1)),imag(eigeinvalues(1)), 'LineStyle','none', 'Marker','.', 'MarkerSize',15, 'LineWidth', 1,'Color', [0.4660 0.6740 0.1880])
hold on
plot(real(eigeinvalues(2)),imag(eigeinvalues(2)), 'LineStyle','none', 'Marker','.', 'MarkerSize',15, 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980])
xlabel('Re\{h$\lambda$\}', 'FontSize',15);
ylabel('Im\{h$\lambda$\}', 'FontSize',15);
legend('RK2', 'IEX4', '$h\lambda_{1}$', '$h\lambda_{2}$', 'Location','northwest', 'FontSize', 12)
% Creation of zoom inside the plot
axes('position',[.35 0.15 0.6 0.74])
box on 
plot(real(diag(h_RK2*lambda_RK2(1,:))), imag(diag(h_RK2*lambda_RK2(1,:))), 'Color',[0.6350 0.0780 0.1840], 'LineStyle','-', 'LineWidth', 2);
hold on
plot(real(diag(h_RK2*lambda_RK2(2,:))), imag(diag(h_RK2*lambda_RK2(2,:))), 'Color',[0.6350 0.0780 0.1840], 'LineStyle','-', 'LineWidth', 2);
% Plot the stability domain for IEX4
plot(real(diag(h_IEX4*lambda_IEX4(1,:))), imag(diag(h_IEX4*lambda_IEX4(1,:))), 'Color',[0.3010 0.7450 0.9330], 'LineStyle','-', 'LineWidth', 2);
plot(real(diag(h_IEX4*lambda_IEX4(2,:))), imag(diag(h_IEX4*lambda_IEX4(2,:))), 'Color',[0.3010 0.7450 0.9330], 'LineStyle','-', 'LineWidth', 2);
plot(real(eigeinvalues(1)),imag(eigeinvalues(1)), 'LineStyle','none', 'Marker','.', 'MarkerSize',15, 'LineWidth', 1,'Color', [0.4660 0.6740 0.1880])
axis tight

% REQUEST 3

% Initializzation of parameters
t0 = 0;     % initial time          [s]
tf = 50;   % Final time            [s]
h_IEX4_vec = [5 1 0.01]; % Time step for IEX4    [s]
qq0 = [param_EX5.C * param_EX5.V0; 0];    % Initial condition

% Initializzation of the parameters for Runge-Kutta 2
alpha_RK2 = [1; 1];
beta_RK2  = [1 0; 1/2 1/2];
h_RK2_vec = [0.00160036 h_MAX_RK2 0.001];            % Time step [s]

% Perform integration to get the exact solution
[tt_exact_ode, qq_exact_ode]   = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), [t0 tf] , qq0);                          % Call ode23s

% Perform integration for the 1st two value of h
[qq_IEX4_1, tt_IEX4_1] = IEX4(A_State, qq0, t0, tf, h_IEX4_vec(1));                                       % Call IEX4
[qq_RK2_1, tt_RK2_1]   = RungeKutta(@ODE_EX5, qq0, t0, tf, h_RK2_vec(1), alpha_RK2, beta_RK2, param_EX5); % Call RK2
[~, qq_ode_IEX4_1]   = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), tt_IEX4_1 , qq0);                          % Call ode23s
[~, qq_ode_RK2_1]    = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), tt_RK2_1, qq0);                            % Call ode23s

% Perform integration for the 1st two value of h
[qq_IEX4_2, tt_IEX4_2] = IEX4(A_State, qq0, t0, tf, h_IEX4_vec(2));                                       % Call IEX4
[qq_RK2_2, tt_RK2_2]   = RungeKutta(@ODE_EX5, qq0, t0, tf, h_RK2_vec(2), alpha_RK2, beta_RK2, param_EX5); % Call RK2
[~, qq_ode_IEX4_2]   = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), tt_IEX4_2 , qq0);                          % Call ode23s
[~, qq_ode_RK2_2]    = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), tt_RK2_2, qq0);                            % Call ode23s

% Perform integration for the 1st two value of h
[qq_IEX4_3, tt_IEX4_3] = IEX4(A_State, qq0, t0, tf, h_IEX4_vec(3));                                       % Call IEX4
[qq_RK2_3, tt_RK2_3]   = RungeKutta(@ODE_EX5, qq0, t0, tf, h_RK2_vec(3), alpha_RK2, beta_RK2, param_EX5); % Call RK2
[~, qq_ode_IEX4_3]   = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), tt_IEX4_3 , qq0);                          % Call ode23s
[~, qq_ode_RK2_3]    = ode23s(@(t, q)ODE_EX5(t, q, param_EX5), tt_RK2_3, qq0);                            % Call ode23s

% Plot the solution with IEX4 and ode23s
% Charge
figure(2)
plot(tt_exact_ode, qq_exact_ode(:, 1), 'LineWidth', 2, 'Color', 'black', 'LineStyle', '--')
hold on
plot(tt_IEX4_1, qq_IEX4_1(1, :), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
plot(tt_IEX4_2, qq_IEX4_2(1, :), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
plot(tt_IEX4_3, qq_IEX4_3(1, :), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('q [C]', 'FontSize', 15)
legend('Exact', strcat('$h = ',num2str(h_IEX4_vec(1)),'$'),...
    strcat('$h = ',num2str(h_IEX4_vec(2)),'$'), strcat('$h = ',num2str(h_IEX4_vec(3)),'$'),...
    'Location', 'northeast')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Current
figure(3)
plot(tt_exact_ode, qq_exact_ode(:, 2), 'LineWidth', 2, 'Color', 'black', 'LineStyle', '--')
hold on
plot(tt_IEX4_1, qq_IEX4_1(2, :), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
plot(tt_IEX4_2, qq_IEX4_2(2, :), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
plot(tt_IEX4_3, qq_IEX4_3(2, :), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('$\frac{dq}{dt}$ [A]', 'FontSize', 15)
legend('Exact', strcat('$h = ',num2str(h_IEX4_vec(1)),'$'),...
    strcat('$h = ',num2str(h_IEX4_vec(2)),'$'), strcat('$h = ',num2str(h_IEX4_vec(3)),'$'),...
    'Location', 'southeast')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot the solution with RK2 and ode23s
% Charge
figure(4)
plot(tt_exact_ode, qq_exact_ode(:, 1), 'LineWidth', 2, 'Color', 'black', 'LineStyle', '--')
hold on
plot(tt_RK2_1, qq_RK2_1(1, :), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
plot(tt_RK2_2, qq_RK2_2(1, :), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
plot(tt_RK2_3, qq_RK2_3(1, :), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('q [C]', 'FontSize', 15)
legend('Exact', strcat('$h = ',num2str(h_RK2_vec(1)),'$'),...
    strcat('$h = ',num2str(h_RK2_vec(2)),'$'), strcat('$h = ',num2str(h_RK2_vec(3)),'$'),...
    'Location', 'northeast')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Current
figure(5)
plot(tt_exact_ode, qq_exact_ode(:, 2), 'LineWidth', 2, 'Color', 'black', 'LineStyle', '--')
hold on
plot(tt_RK2_1, qq_RK2_1(2, :), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
plot(tt_RK2_2, qq_RK2_2(2, :), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
plot(tt_RK2_3, qq_RK2_3(2, :), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('$\frac{dq}{dt}$ [A]', 'FontSize', 15)
legend('Exact', strcat('$h = ',num2str(h_RK2_vec(1)),'$'),...
    strcat('$h = ',num2str(h_RK2_vec(2)),'$'), strcat('$h = ',num2str(h_RK2_vec(3)),'$'),...
    'Location', 'northwest')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot the error between solution with IEX4 and ode23s
% Charge
figure(6)
semilogy(tt_IEX4_1, abs(qq_ode_IEX4_1(:,1)' - qq_IEX4_1(1, :)), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
hold on
semilogy(tt_IEX4_2, abs(qq_ode_IEX4_2(:,1)' - qq_IEX4_2(1, :)), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
semilogy(tt_IEX4_3, abs(qq_ode_IEX4_3(:,1)' - qq_IEX4_3(1, :)), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('q [C]', 'FontSize', 15)
legend(strcat('$h = ',num2str(h_IEX4_vec(1)),'$'),...
    strcat('$h = ',num2str(h_IEX4_vec(2)),'$'), strcat('$h = ',num2str(h_IEX4_vec(3)),'$'),...
    'Location', 'southeast')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Current
figure(7)
semilogy(tt_IEX4_1, abs(qq_ode_IEX4_1(:,2)' - qq_IEX4_1(2, :)), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
hold on
semilogy(tt_IEX4_2, abs(qq_ode_IEX4_2(:,2)' - qq_IEX4_2(2, :)), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
semilogy(tt_IEX4_3, abs(qq_ode_IEX4_3(:,2)' - qq_IEX4_3(2, :)), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('$\frac{dq}{dt}$ [A]', 'FontSize', 15)
legend(strcat('$h = ',num2str(h_IEX4_vec(1)),'$'),...
    strcat('$h = ',num2str(h_IEX4_vec(2)),'$'), strcat('$h = ',num2str(h_IEX4_vec(3)),'$'),...
    'Location', 'southeast')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Plot the error between solution with RK2 and ode23s
% Charge
figure(8)
semilogy(tt_RK2_1, abs(qq_ode_RK2_1(:,1)' - qq_RK2_1(1, :)), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
hold on
semilogy(tt_RK2_2, abs(qq_ode_RK2_2(:,1)' - qq_RK2_2(1, :)), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
semilogy(tt_RK2_3, abs(qq_ode_RK2_3(:,1)' - qq_RK2_3(1, :)), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('q [C]', 'FontSize', 15)
legend(strcat('$h = ',num2str(h_RK2_vec(1)),'$'),...
    strcat('$h = ',num2str(h_RK2_vec(2)),'$'), strcat('$h = ',num2str(h_RK2_vec(3)),'$'),...
    'Location', 'southeast')
xlim([0 +Inf])
ylim([-Inf +Inf])
% Current
figure(9)
semilogy(tt_RK2_1, abs(qq_ode_RK2_1(:,2)' - qq_RK2_1(2, :)), 'LineWidth', 1.5, 'Color', [0.6350 0.0780 0.1840])
hold on
semilogy(tt_RK2_2, abs(qq_ode_RK2_2(:,2)' - qq_RK2_2(2, :)), 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250])
semilogy(tt_RK2_3, abs(qq_ode_RK2_3(:,2)' - qq_RK2_3(2, :)), 'LineWidth', 1.5,'Color', [0.3010 0.7450 0.9330])
xlabel('Time [s]', 'FontSize', 15);
ylabel('$\frac{dq}{dt}$ [A]', 'FontSize', 15)
legend(strcat('$h = ',num2str(h_RK2_vec(1)),'$'),...
    strcat('$h = ',num2str(h_RK2_vec(2)),'$'), strcat('$h = ',num2str(h_RK2_vec(3)),'$'),...
    'Location', 'southeast')
xlim([0 +Inf])
ylim([-Inf +Inf])

% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'eigen_stabreg_IEX4.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'q_sol_IEX4.png','Resolution',600);

    % Saving 3rd figure
    figure(3)
    exportgraphics(gcf,'i_sol_IEX4.png','Resolution',600);

    % Saving 4th figure
    figure(4)
    exportgraphics(gcf,'q_sol_RK2.png','Resolution',600);

    % Saving 5th figure
    figure(5)
    exportgraphics(gcf,'i_sol_RK2.png','Resolution',600);

    % Saving 6th figure
    figure(6)
    exportgraphics(gcf,'q_err_sol_IEX4.png','Resolution',600);

    % Saving 7th figure
    figure(7)
    exportgraphics(gcf,'i_err_sol_IEX4.png','Resolution',600);

    % Saving 8th figure
    figure(8)
    exportgraphics(gcf,'q_err_sol_RK2.png','Resolution',600);

    % Saving 9th figure
    figure(9)
    exportgraphics(gcf,'i_err_sol_RK2.png','Resolution',600);
end

%% EXERCISE 6
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

fprintf('\n EXERCISE 6\n')

% Initializzation of the struct used to pass parameters to the function
param_EX6.k = 0.9;          % Attenuation factor [-]
param_EX6.rho = 1.225;      % Air density        [kg/m^3]
param_EX6.mb = 1;           % Ball mass          [kg]
param_EX6.Ab = 0.07;        % Ball area          [m^2]
param_EX6.Vb = 0.014;       % Ball volume        [m^3]
param_EX6.Cd = 1.17;        % Drag coefficient   [-]
param_EX6.g = 9.81;         % Gravitational acc. [m/s^2]
param_EX6.MinBounce = false;% Flag used to zeroing the acceleration

% Initial and finl time of integration
t0 = 0;  % [s]
tf = 10; % [s]

% Set the first value of the initial integration time = t0
ti = t0;

% Initializzation of the intial condition
x0 = 10;          % [m]
v0 = 0;           % [m/s]
xx0 = [x0; v0]; 
N_iter_R1 = 0;    % Number of integarions
MinBounce = 1e-6; % [m]

% REQUEST 1
% Set option for the ode
options_EX6 = odeset('Events',@(t, xx) bounce(t, xx));

% Initializzation of variables
tt_R1 = [];      % Time vector
xx_R1 = [];       % Position
tt_Jump_R1 = []; % Time instant of jump
xx_Jump_R1 = []; % State at jump

% While cycle used to continue the integration
while ti < tf
    
    % Perfoming integration
    [tt_temp, xx_temp, te_temp, xxe_temp, ~] = ode45(@(t, xx) ODE_EX6(t, xx, param_EX6), [ti tf], xx0, options_EX6);

    % Saving variables;
    tt_R1 = [tt_R1; NaN; tt_temp];
    xx_R1 = [xx_R1; NaN(1, 2); xx_temp];

    % Check if the ball has touched the ground
    if~(isempty(te_temp)) 
        
        % Saving Jump instant
        tt_Jump_R1 = [tt_Jump_R1; tt_temp(end)]; %#ok<*AGROW>
        xx_Jump_R1 = [xx_Jump_R1; xx_temp(end, :)];

        % Set the new initial time
        ti = te_temp(end);

        % Computation of the new initial condition
        if max(xx_temp(:, 1)) < MinBounce

            xx0 = [xxe_temp(end,1); 0];
            param_EX6.MinBounce = true;
        else
            xx0 = [xxe_temp(end,1); -param_EX6.k*xxe_temp(end,2)];
        end

        N_iter_R1 = N_iter_R1 + 1;
    else

        % Set the condition to exit the while
        ti = tf;
    end
end

% Plot position
figure(1)
plot(tt_R1, xx_R1(:, 1), 'LineWidth',2,  'Color', [0.4940 0.1840 0.5560]);
hold on
plot(tt_Jump_R1, xx_Jump_R1(:, 1), 'LineWidth',2, 'Color', [0.3010 0.7450 0.9330], 'Marker','.', 'LineStyle','none', 'MarkerSize', 25);
xlabel('Time [s]'); 
ylabel('x [m]'); 
legend('x', 'Bounce');
xlim([0 +Inf]);
ylim([0 +Inf]);

% Plot velocity
figure(2)
plot(tt_R1, xx_R1(:, 2), 'LineWidth',2,  'Color', [0.9290 0.6940 0.1250]);
hold on
plot(tt_Jump_R1, xx_Jump_R1(:, 2), 'LineWidth',2, 'Color', [0.3010 0.7450 0.9330], 'Marker','.', 'LineStyle','none', 'MarkerSize', 25);
xlabel('Time [s]'); 
ylabel('v [m/s]'); 
legend('Velocity', 'Bounce')
xlim([0 +Inf]);
ylim([-Inf +Inf]);

% REQUEST 2

% Initializzation of the variables
param_EX6.rho = 15; % Air density [kg/m^3]
param_EX6.MinBounce = false;% Flag used to zeroing the acceleration
ti = t0;            % Initial time
xx0 = [x0; v0];     % Initial condition
N_iter_R2 = 0;      % Number of integarions
tt_R2 = [];         % Time vector
xx_R2 = [];         % States
tt_Jump_R2 = [];    % Time instant of jump
xx_Jump_R2 = [];    % State at jump

% While cycle used to continue the integration
while ti < tf

    % Perfoming integration
    [tt_temp, xx_temp, te_temp, xxe_temp, ~] = ode45(@(t, xx) ODE_EX6(t, xx, param_EX6), [ti tf], xx0, options_EX6);

    % Saving variables;
    tt_R2 = [tt_R2; NaN; tt_temp];
    xx_R2 = [xx_R2; NaN(1, 2); xx_temp];

    % Check if the ball has touched the ground
    if~(isempty(te_temp))
        
        % Saving Jump instant
        tt_Jump_R2 = [tt_Jump_R2; tt_temp(end)]; 
        xx_Jump_R2 = [xx_Jump_R2; xx_temp(end, :)]; 

        % Set the new initial time
        ti = te_temp(end);
        
        % Computation of the new initial condition
        if max(xx_temp(:, 1)) < MinBounce

            xx0 = [xxe_temp(end,1); 0];
            param_EX6.MinBounce = true;
        else
            xx0 = [xxe_temp(end,1); -param_EX6.k*xxe_temp(end,2)];
        end

        N_iter_R2 = N_iter_R2 + 1;
    else
        % Set the condition to exit the while
        ti = tf;
    end
end

% Plot position
figure(3)
plot(tt_R2, xx_R2(:, 1), 'LineWidth',2,  'Color',[0.4940 0.1840 0.5560]);
hold on
plot(tt_Jump_R2, xx_Jump_R2(:, 1), 'LineWidth',2, 'Color', [0.3010 0.7450 0.9330], 'Marker','.', 'LineStyle','none', 'MarkerSize', 25);
xlabel('Time [s]'); 
ylabel('x [m]'); 
legend('x', 'Bounce');
xlim([0 +Inf]);
ylim([0 +Inf]);

% Plot velocity
figure(4)
plot(tt_R2, xx_R2(:, 2), 'LineWidth',2,  'Color', [0.9290 0.6940 0.1250]);
hold on
plot(tt_Jump_R2, xx_Jump_R2(:, 2), 'LineWidth',2, 'Color', [0.3010 0.7450 0.9330], 'Marker','.', 'LineStyle','none', 'MarkerSize', 25);
xlabel('Time [s]'); 
ylabel('v [m/s]'); 
legend('Velocity', 'Bounce')
xlim([0 +Inf]);
ylim([-Inf +Inf]);

% REQUEST 3

% Initializzation of the variables
param_EX6.rho = 60; % Air density [kg/m^3]
param_EX6.MinBounce = false;% Flag used to zeroing the acceleration
ti = t0;            % Initial time
xx0 = [x0; v0];     % Initial condition
N_iter_R3 = 0;      % Number of integarions
tt_R3 = [];         % Time vector
xx_R3 = [];         % States
tt_Jump_R3 = [];    % Time instant of jump
xx_Jump_R3 = [];    % State at jump

% While cycle used to continue the integration
while ti < tf

    % Perfoming integration
    [tt_temp, xx_temp, te_temp, xxe_temp, ~] = ode45(@(t, xx) ODE_EX6(t, xx, param_EX6), [ti tf], xx0, options_EX6);

    % Saving variables;
    tt_R3 = [tt_R3; NaN; tt_temp];
    xx_R3 = [xx_R3; NaN(1, 2); xx_temp];

    % Check if the ball has touched the ground
    if~(isempty(te_temp))
        
        % Saving Jump instant
        tt_Jump_R3 = [tt_Jump_R3; tt_temp(end)];
        xx_Jump_R3 = [xx_Jump_R3; xx_temp(end, :)];

        % Set the new initial time
        ti = te_temp(end);
        
        % Computation of the new initial condition
        if max(xx_temp(:, 1)) < MinBounce

            xx0 = [xxe_temp(end,1); 0];
            param_EX6.MinBounce = true;
        else
            xx0 = [xxe_temp(end,1); -param_EX6.k*xxe_temp(end,2)];
        end

        N_iter_R2 = N_iter_R2 + 1;
    else
        % Set the condition to exit the while
        ti = tf;
    end
end

% Plot position
figure(5)
plot(tt_R3, xx_R3(:, 1), 'LineWidth',2,  'Color', [0.4940 0.1840 0.5560]);
hold on
xlabel('Time [s]'); 
ylabel('x [m]'); 
xlim([0 +Inf]);
ylim([0 +Inf]);

% Plot velocity
figure(6)
plot(tt_R3, xx_R3(:, 2), 'LineWidth',2,  'Color', [0.9290 0.6940 0.1250]);
hold on
xlabel('Time [s]'); 
ylabel('v [m/s]'); 
xlim([0 +Inf]);
ylim([-Inf +Inf]);

% Display results
fprintf('Number of bounce rho(1.225 kg/m3) = %d\n', N_iter_R1)
fprintf('Number of bounce rho(15 kg/m3) = %d\n', N_iter_R2)
fprintf('Number of bounce rho(60 kg/m3) = %d\n', N_iter_R3)
% REQUEST 4

% Initializzation of the parameters for Runge-Kutta 4
alpha_RK4 = [1/2; 1/2; 1; 1];                                   % Alpha vector
beta_RK4 = [1/2 0 0 0; 0 1/2 0 0; 0 0 1 0; 1/6 1/3 1/3 1/6];    % Beta Matrix
h_RK4 = 3;                                                      % Time step for RK4

% h_max
v_eq = fzero(@(v) -param_EX6.g * param_EX6.mb - param_EX6.rho * param_EX6.Cd * param_EX6.Ab * 0.5 * v * abs(v) + param_EX6.rho * param_EX6.Vb * param_EX6.g, 0);
F_lin = - param_EX6.rho * param_EX6.Cd * param_EX6.Ab * v_eq ;
h_max = -2.7853/-F_lin;
fprintf('\n The maximum h for RK4 is %.4f', h_max)

% Initial condition
xx0 = [x0; v0];

% Call RK4
[xx_rk4, t_RK4] = RungeKutta(@ODE_EX6, xx0, t0, tf, h_RK4, alpha_RK4, beta_RK4, param_EX6);

% Peform again the integarion using h<h_max
% Call RK4
h_RK4_2 = 0.5;
[xx_rk4_2, t_RK4_2] = RungeKutta(@ODE_EX6, xx0, t0, tf, h_RK4_2, alpha_RK4, beta_RK4, param_EX6);


% Plot RK4 solution
figure(7)
plot(t_RK4, xx_rk4(1, :), 'LineWidth',2, 'Color', [0.4940 0.1840 0.5560]);
xlabel('Time [s]'); 
ylabel('x [m]'); 

% Plot RK4 vs ode45
figure(8)
hold on
plot(t_RK4, xx_rk4(2, :), 'LineWidth',2, 'Color', [0.9290 0.6940 0.1250]);
xlabel('Time [s]'); 
ylabel('v [m/s]'); 

% Perform integration with ode45 with the same step of RK4 to compute the
% error
[~, xx_R4, te_R4, ~, ~] = ode45(@(t, xx) ODE_EX6(t, xx, param_EX6), t_RK4, xx0, options_EX6);


% Perform integration with ode45 with the same step of RK4 with h < h_max to compute the
% error
[~, xx_R4_2, te_R4_2, ~, ~] = ode45(@(t, xx) ODE_EX6(t, xx, param_EX6), t_RK4_2, xx0, options_EX6);

% Plot the error
figure(9)
semilogy(t_RK4, abs(xx_rk4(1,:)' - xx_R4(:, 1)), 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold on
semilogy(t_RK4, abs(xx_rk4(2,:)' - xx_R4(:, 2)), 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250])
xlabel('Time [s]'); 
ylabel('Error');
legend('Position error [m]', 'Velocity error [m/s]', 'Location', 'northwest')

% Plot the error
figure(10)
semilogy(t_RK4_2, abs(xx_rk4_2(1,:)' - xx_R4_2(:, 1)), 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560])
hold on
semilogy(t_RK4_2, abs(xx_rk4_2(2,:)' - xx_R4_2(:, 2)), 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250])
xlabel('Time [s]'); 
ylabel('Error');
legend('Position error [m]', 'Velocity error [m/s]')


% Save plots
if SAVEPLOTS

    % Saving 1st figure
    figure(1)
    exportgraphics(gcf,'x_rho1.png','Resolution',600);

    % Saving 2nd figure
    figure(2)
    exportgraphics(gcf,'v_rho1.png','Resolution',600);

    % Saving 3rd figure
    figure(3)
    exportgraphics(gcf,'x_rho2.png','Resolution',600);

    % Saving 4th figure
    figure(4)
    exportgraphics(gcf,'v_rho2.png','Resolution',600);

    % Saving 5th figure
    figure(5)
    exportgraphics(gcf,'x_rho3.png','Resolution',600);

    % Saving 6th figure
    figure(6)
    exportgraphics(gcf,'v_rho3.png','Resolution',600);

    % Saving 7th figure
    figure(7)
    exportgraphics(gcf,'x_rho3_RK4.png','Resolution',600);

    % Saving 8th figure
    figure(8)
    exportgraphics(gcf,'v_rho3_RK4.png','Resolution',600);

    % Saving 9th figure
    figure(9)
    exportgraphics(gcf,'err_rho3_RK4.png','Resolution',600);

    % Saving 10th figure
    figure(10)
    exportgraphics(gcf,'err_rho3_RK4_hmax.png','Resolution',600);

end

%% FUNCTION

%-------------------------------------------------------------------------%
% function:NewtonSolver.m 
function [xsol, fval, exitflag] = NewtonSolver(f, x0, options, f_dot)
%-------------------------------------------------------------------------%
%                                                                         
% NewtonSolver: Newton solver                    
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [xsol, fval, exitflag] = NewtonSolver(f, x0, options, f_dot)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  f            [1]   function                                   [-]
%  x0           [1]   initial condtion                           [-]  
%  options      [-]   struct for the options                     [-]
%  f_dot        [1]   derivative of the function                 [-]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  xsol         [1]     solution                                 [-]
%  fval         [1]     function evaluated at the solution       [-]
%  exitflag     [1]     flag used to tell if the solver 
%                       has found a solution                     [-]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Extract the options from the struct
tol = options.tol;                       % tolerance
differenceType = options.differenceType; % type of finite difference
iter = options.iter;                     % Flag to display the iteration
N_MAX = options.NMAXiter;                % Max number of iterations

% Function evaluated at x0
f_x0 = f(x0);

% Check if display the iteration
if iter
    fprintf('\n x = %f \t f(x) = %f', x0, f_x0);
end

% Check that x0 is different from zero
if f_x0 ~= 0             

    % Update the number of iteration
    options.i = options.i + 1;

    % Computation of the error
    fval = abs(f_x0);    

    % Check if the error is above the tolerance and if the number of
    % iterations is below NMAX
    if fval > tol  && options.i <= N_MAX    

        % Check if the derivative has been given as input
        if nargin == 4 

            % Compute the new point
            xk = x0 - f_x0/f_dot(x0);

            % Call NewtonSolver with new point
            [xsol, fval, exitflag] = NewtonSolver(f, xk, options, f_dot);
        else
            % Computation of the  derivative using a numerical approach

            % Definition of the deltax
            epsilon = max(sqrt(eps), sqrt(eps)*abs(x0)); 

            % Check if the derivative needs to be computed with forward or
            % central difference
            if strcmpi(differenceType, 'centered')

                % Computation 
                f_dot_x0 = (f(x0 + epsilon) - f(x0 - epsilon)) / 2 / epsilon;
            elseif strcmpi(differenceType, 'forward')

                % Computation 
                f_dot_x0 = (f(x0 + epsilon) - f_x0) / epsilon; 
            else
                display('Error in calling NewtonMethod_f function ', differenceType,' is a type of \n differentiation not defined')
            end

            % Compute the new point
            xk = x0 - f_x0/f_dot_x0;

            % Call NewtonSolver with new point
            [xsol, fval, exitflag] = NewtonSolver(f, xk, options);
        end
    else
        % Check the number of iterations
        if  options.i <= N_MAX
            % Solution found
            xsol = x0;
            exitflag = 1;
        else
            % Error max number of iteration reached
            fprintf('Maximum number of itrations reached\n');
            exitflag = -1;
            xsol = x0;
        end
    end
else
    % Exatc solution found
    fprintf('Exact solution found\n');
    exitflag = 1;
end

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:RungeKutta.m 
function [x, t] = RungeKutta(f, x0, t0, tf, h, alpha, beta, param)
%-------------------------------------------------------------------------%
%                                                                         
% RungeKutta: Generic algorithm for runge kutta                    
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [x, t] = RungeKutta(f, x0, t0, tf, h, alpha, beta, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  f            [1]   function                                   [-]
%  x0           [dx1] initial condtion                           [-]  
%  t0           [1]   initial time                               [s]
%  tf           [1]   final time                                 [s]
%  h            [1]   step size                                  [s]
%  alpha        [nx1] alpha vector                               [-]
%  beta         [nxn] matrix for weight on the stae derivatives  [-]
%  param        [-]   struct which contains the parameters used
%                     in the ode of the problem
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  x         [dxN]     solution                                 [-]
%  t         [Nx1]     time vector                              [-]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Get the dimension of the iniatial condition
dim = length(x0);

% Creation of time vector
t = t0 : h : tf;

% Get the number of points between t0 and tf
n = length(t) - 1;

% Initializzation of the solution vector
x = zeros(dim, n + 1);

% Computation of the number of predictor
n_predictor = length(alpha) - 1;

% Assign the initial state to the first elemnt of the solution vector
x(:, 1) = x0;

% For used to compute the solution for every time instant
for i = 1 : n

    % Extract the current solution
    x_k = x(:, i);

    % Extract the current time instant
    t_k = t(i);

    % Function evaluation at the current time and solution
    f_k = f(t_k, x_k, param);

    % Initializzation of the predictor matrix to improve computational
    % speed
    x_predictor = zeros(dim, n_predictor);

    % For used to compute the predictor 
    for j = 1 : n_predictor

        % Intializzation of the sum of terms used to compute the predictor
        predictorSum = zeros(dim, 1);

        % For used to compute the sum
        for m = 1 : j
            if m == 1
                predictorSum = beta(j, m) * f_k;
            else
                predictorSum = predictorSum + beta(j, m) * f(t_k + alpha(m - 1) * h, x_predictor(:, m - 1), param);
            end
        end

        % Computation of the predictor
        x_predictor(:, j) = x_k + h * predictorSum;
    end

    % Initializzation of the sum used in the corrector
    correctorSum = zeros(dim, 1);

    % For used to compute the corrector
    for m = 1 : n_predictor + 1
        if m == 1
            correctorSum = beta(end, m) * f_k;
        else
            correctorSum = correctorSum + beta(end, m) * f(t_k + alpha(m - 1) * h, x_predictor(:, m - 1), param);
        end
    end

    % Assign the computed solution to the solution vector
    x(:, i + 1) = x_k + alpha(end) * h * correctorSum;
end

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:IEX4.m 
function [x, t] = IEX4(A_state, x0, t0, tf, h)
%-------------------------------------------------------------------------%
%                                                                         
% IEX4: Implicit extrapolation technicque of order 4 for system in state space representation                   
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [x, t] = IEX4(A_state, x0, t0, tf, h)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  A_state      [dxd] Matrix A of state space representation     [-]
%  x0           [dx1] initial condtion                           [-]  
%  t0           [1]   initial time                               [s]
%  tf           [1]   final time                                 [s]
%  h            [1]   step size                                  [s]
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  x         [dxN]     solution                                 [-]
%  t         [Nx1]     time vector                              [-]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Get the dimension of the iniatial condition
dim = length(x0);

% Get the number of points between t0 and tf
n = round((tf - t0)/h);

% Creation of time vector
t = linspace(t0, tf, n + 1);

% Initializzation of the solution vector
x = zeros(dim, n + 1);

% Assign the initial state to the first elemnt of the solution vector
x(:, 1) = x0;

% Operator that maps x_k into x_k+1 for IEX4
FIEX4 = @(A)  -1/6 * (eye(2) - h * A)^(-1)...
               + 4 * (eye(2) - h/2 * A)^(-2)...
            - 27/2 * (eye(2) - h/3 * A)^(-3)...
            + 32/3 * (eye(2) - h/4 * A)^(-4);
 
for j = 1 : n
    
    % Extract x_k from the solution vector
    x_k = x(:, j);

    % Computation of x_k+1 as FIEX4 * x_k
    x(:, j + 1) = FIEX4(A_state) * x_k;
end

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:stabilityDomain.m 
function [h_vec, lambda] = stabilityDomain(F, alpha_vec, h0)
%-------------------------------------------------------------------------%
%                                                                         
% stabilityDomain: Function which gives the eigenvector and h for drawing the stabilty region                     
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [h_vec, lambda] = stabilityDomain(F, alpha_vec, h0)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  F            [2x2] function for mapping x_k into x_k+1        [-] 
%  alpha        [nx1] vector of alpha typically 0 to pi          [-]
%  h0           [1]   initial guess for h                        [-]  
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  h_vec        [nx1]     values of h for every alpha            [-]
%  lambda       [2xn]     eigenvector                            [-]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Initializzation of variables
nPoints = length(alpha_vec);            % Number of point between 0 and pi
h_vec = zeros(length(alpha_vec), 1);    % Vector for the values of h
lambda = zeros(2, nPoints);             % Matrix for the eigenvalues of A

% Initializzation of matrix A
A = @(alpha) [0 1; -1 2*cos(alpha)];

% Function which allows to find h for a given alpha
f_h = @(h, alpha) 1 - max(abs(eig(F(h, alpha))));

% For for compute h for F
for i = 1 : nPoints

    % at first iteration h0 is used, for other numerical continuation so
    % the previous solution is used
    if i == 1

        % Call fzero
        h_vec(i) = fzero(@(h) f_h(h, alpha_vec(i)), h0);
    else

        % Call fzero
        h_vec(i) = fzero(@(h) f_h(h, alpha_vec(i)), h_vec(i - 1));
    end

    % Get eigenvalues of A
    lambda(:, i) = eig(A(alpha_vec(i)));

end

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:ODE_EX2.m 
function [dvdt] = ODE_EX2(t, v, param)
%-------------------------------------------------------------------------%
%                                                                         
% ODE_EX2: ODE for exercise 2
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dvdt] = ODE_EX2(t, v, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [-]
%  v            [1]   velocity                              [m/s]  
%  param        [-]   struct which contains the parameters used
%                     in the ode of the problem
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dvdt         [1]   ode                                   [m/s^2]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Extraction of the parameters from the struct
rho = param.rho;     % Density    [km/m^3]
Cd = param.Cd;       % Drag coef. [-] 
Am = param.Am;       % Area       [m^2]
m0 = param.m0;       % Mass       [kg]
cm = param.cm;       %            [kg/s]
f = param.f;         % Force      [N]
alpha = param.alpha; %            [Ns/m]

% Computation of the mass at the specified time
m = m0 - cm * t;

% Computation of the Force ath the specified time
F = -0.5 * rho * Cd * Am * v^2;

% Computation of the acceleration
dvdt = (F + f - alpha * v)/m;

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:ODE_EX4.m 
function [dTdt] = ODE_EX4(~, T, param)
%-------------------------------------------------------------------------%
%                                                                         
% ODE_EX4: ODE for exercise 4
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dTdt] = ODE_EX4(t, T, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [-]
%  T            [1]   temperature                           [K]  
%  param        [-]   struct which contains the parameters used
%                     in the ode of the problem
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dTdt         [1]   ode                                   [K/s]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Extraction of the parameters from the struct
Kc = param.Kc;  % Convective heat coeff.      [J/(s K)]
Kr = param.Kr;  % Radiative heat coeff.       [J/(s K^4)]
Ta = param.Ta;  % Surrounding air temperature [K]
C = param.C;    % MAss thermal capacity       [J/K]
 
% Variation of the temperature w.r.t time
dTdt = (-Kc*(T - Ta) - Kr*(T^4 - Ta^4))/C;

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:ODE_EX5.m 
function [dqdt] = ODE_EX5(~, q, param)
%-------------------------------------------------------------------------%
%                                                                         
% ODE_EX5: ODE for exercise 5
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dqdt] = ODE_EX5(~, q, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [-]
%  q            [2x1] state vector                          [V; V/s]  
%  param        [-]   struct which contains the parameters used
%                     in the ode of the problem
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dqdt         [2x1]  ode                                   [V/s; V/s^2]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Extraction of the parameters from the struct
R = param.R;  % Resistance      [Ohm]
L = param.L;  % Inductance      [H]
C = param.C;  % Conductance     [F]
 
% Matrix for the state variable form
A = [0, 1; -1/L/C, -R/L];

% ode
dqdt = A * q;

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:ODE_EX6.m 
function [dxdt] = ODE_EX6(~, xx, param)
%-------------------------------------------------------------------------%
%                                                                         
% ODE_EX6: ODE for exercise 6
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [dxdt] = ODE_EX6(t, xx, param)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [-]
%  xx           [2x1] position and velocity                 [m; m/s]  
%  param        [-]   struct which contains the parameters used
%                     in the ode of the problem
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  dvdt         [2x1]   ode                                   [m/s; m/s^2]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

% Extraction of the parameters from the struct
rho = param.rho; % Density           [kg/m^3]
mb = param.mb;   % Ball mass         [kg]
Ab = param.Ab;   % Ball area         [m^2]
Vb = param.Vb;   % Ball volume       [m^3]
Cd = param.Cd;   % Drag coeff.       [-]
g = param.g;     % Gravitationa acc. [m/s^2]

% Extract the velocity from the state
v = xx(2);

% Computation of the force
FA = rho * Vb * g;

% Computation of the drag force
FD = -0.5 * rho * Cd * Ab * v * abs(v);

% Assemble the ODE
dxdt = [v;...               % velocity
       -g + FD/mb + FA/mb]; % accelaration

% Check if the bounce limit has been reached
if param.MinBounce 
    dxdt(2) = 0;
end

end
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% function:bounce.m 
function [value,isterminal,direction] = bounce(~, xx)
%-------------------------------------------------------------------------%
%                                                                         
% bounce: event function for exercise 6 which detect when the ball touches
% the ground
%                                                                         
%-------------------------------------------------------------------------%
% PROTOTYPE:
%   [value,isterminal,direction] = bounce(t, xx)
%
%-------------------------------------------------------------------------%
% INPUT ARGUMENTS:
%  t            [1]   time                                  [-]
%  xx           [2x1] position and velocity                 [m; m/s]  
%
%-------------------------------------------------------------------------%
% OUTPUT ARGUMENTS:
%  value        [1]   The value that we want to be zero     [m]
%  isterminal   [1]   Halt integration                      [-]
%  direction    [1]   direction to approach the zero        [-]
%
% ------------------------------------------------------------------------%
% AUTHOR:
%  Michele Puzzolante
%
%-------------------------------------------------------------------------%
% VERSIONS: 
%  22/10/2024: First version
%
%-------------------------------------------------------------------------%

value = xx(1);     % Ball's height
isterminal = true;
direction = -1;

end
%-------------------------------------------------------------------------%