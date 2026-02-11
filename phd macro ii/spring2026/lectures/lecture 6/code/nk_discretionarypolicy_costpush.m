%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Save empty dates and dseries objects in memory.
dates('initialize');
dseries('initialize');
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'nk_discretionarypolicy_costpush';
M_.dynare_version = '4.5.1';
oo_.dynare_version = '4.5.1';
options_.dynare_version = '4.5.1';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('nk_discretionarypolicy_costpush.log');
M_.exo_names = 'e';
M_.exo_names_tex = 'e';
M_.exo_names_long = 'e';
M_.endo_names = 'x';
M_.endo_names_tex = 'x';
M_.endo_names_long = 'x';
M_.endo_names = char(M_.endo_names, 'pi');
M_.endo_names_tex = char(M_.endo_names_tex, 'pi');
M_.endo_names_long = char(M_.endo_names_long, 'pi');
M_.endo_names = char(M_.endo_names, 'ihat');
M_.endo_names_tex = char(M_.endo_names_tex, 'ihat');
M_.endo_names_long = char(M_.endo_names_long, 'ihat');
M_.endo_names = char(M_.endo_names, 'u');
M_.endo_names_tex = char(M_.endo_names_tex, 'u');
M_.endo_names_long = char(M_.endo_names_long, 'u');
M_.endo_partitions = struct();
M_.param_names = 'kappa_val';
M_.param_names_tex = 'kappa\_val';
M_.param_names_long = 'kappa_val';
M_.param_names = char(M_.param_names, 'beta_val');
M_.param_names_tex = char(M_.param_names_tex, 'beta\_val');
M_.param_names_long = char(M_.param_names_long, 'beta_val');
M_.param_names = char(M_.param_names, 'phi_pi_val');
M_.param_names_tex = char(M_.param_names_tex, 'phi\_pi\_val');
M_.param_names_long = char(M_.param_names_long, 'phi_pi_val');
M_.param_names = char(M_.param_names, 'alpha_x_val');
M_.param_names_tex = char(M_.param_names_tex, 'alpha\_x\_val');
M_.param_names_long = char(M_.param_names_long, 'alpha_x_val');
M_.param_names = char(M_.param_names, 'rho_u_val');
M_.param_names_tex = char(M_.param_names_tex, 'rho\_u\_val');
M_.param_names_long = char(M_.param_names_long, 'rho_u_val');
M_.param_names = char(M_.param_names, 'std_u_val');
M_.param_names_tex = char(M_.param_names_tex, 'std\_u\_val');
M_.param_names_long = char(M_.param_names_long, 'std_u_val');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 4;
M_.param_nbr = 6;
M_.orig_endo_nbr = 4;
M_.aux_vars = [];
M_.Sigma_e = zeros(1, 1);
M_.Correlation_matrix = eye(1, 1);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = 1;
M_.det_shocks = [];
options_.linear = 1;
options_.block=0;
options_.bytecode=0;
options_.use_dll=0;
M_.hessian_eq_zero = 1;
