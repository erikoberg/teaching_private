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
M_.fname = 'nk_fullsystem';
M_.dynare_version = '4.5.1';
oo_.dynare_version = '4.5.1';
options_.dynare_version = '4.5.1';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('nk_fullsystem.log');
M_.exo_names = 'e_nu';
M_.exo_names_tex = 'e\_nu';
M_.exo_names_long = 'e_nu';
M_.exo_names = char(M_.exo_names, 'e_a');
M_.exo_names_tex = char(M_.exo_names_tex, 'e\_a');
M_.exo_names_long = char(M_.exo_names_long, 'e_a');
M_.endo_names = 'yhat';
M_.endo_names_tex = 'yhat';
M_.endo_names_long = 'yhat';
M_.endo_names = char(M_.endo_names, 'chat');
M_.endo_names_tex = char(M_.endo_names_tex, 'chat');
M_.endo_names_long = char(M_.endo_names_long, 'chat');
M_.endo_names = char(M_.endo_names, 'nhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'nhat');
M_.endo_names_long = char(M_.endo_names_long, 'nhat');
M_.endo_names = char(M_.endo_names, 'mchat');
M_.endo_names_tex = char(M_.endo_names_tex, 'mchat');
M_.endo_names_long = char(M_.endo_names_long, 'mchat');
M_.endo_names = char(M_.endo_names, 'what');
M_.endo_names_tex = char(M_.endo_names_tex, 'what');
M_.endo_names_long = char(M_.endo_names_long, 'what');
M_.endo_names = char(M_.endo_names, 'dhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'dhat');
M_.endo_names_long = char(M_.endo_names_long, 'dhat');
M_.endo_names = char(M_.endo_names, 'pi');
M_.endo_names_tex = char(M_.endo_names_tex, 'pi');
M_.endo_names_long = char(M_.endo_names_long, 'pi');
M_.endo_names = char(M_.endo_names, 'ihat');
M_.endo_names_tex = char(M_.endo_names_tex, 'ihat');
M_.endo_names_long = char(M_.endo_names_long, 'ihat');
M_.endo_names = char(M_.endo_names, 'rhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'rhat');
M_.endo_names_long = char(M_.endo_names_long, 'rhat');
M_.endo_names = char(M_.endo_names, 'nu');
M_.endo_names_tex = char(M_.endo_names_tex, 'nu');
M_.endo_names_long = char(M_.endo_names_long, 'nu');
M_.endo_names = char(M_.endo_names, 'a');
M_.endo_names_tex = char(M_.endo_names_tex, 'a');
M_.endo_names_long = char(M_.endo_names_long, 'a');
M_.endo_partitions = struct();
M_.param_names = 'lambda_val';
M_.param_names_tex = 'lambda\_val';
M_.param_names_long = 'lambda_val';
M_.param_names = char(M_.param_names, 'beta_val');
M_.param_names_tex = char(M_.param_names_tex, 'beta\_val');
M_.param_names_long = char(M_.param_names_long, 'beta_val');
M_.param_names = char(M_.param_names, 'varphi_val');
M_.param_names_tex = char(M_.param_names_tex, 'varphi\_val');
M_.param_names_long = char(M_.param_names_long, 'varphi_val');
M_.param_names = char(M_.param_names, 'phi_pi_val');
M_.param_names_tex = char(M_.param_names_tex, 'phi\_pi\_val');
M_.param_names_long = char(M_.param_names_long, 'phi_pi_val');
M_.param_names = char(M_.param_names, 'LS_val');
M_.param_names_tex = char(M_.param_names_tex, 'LS\_val');
M_.param_names_long = char(M_.param_names_long, 'LS_val');
M_.param_names = char(M_.param_names, 'rho_nu_val');
M_.param_names_tex = char(M_.param_names_tex, 'rho\_nu\_val');
M_.param_names_long = char(M_.param_names_long, 'rho_nu_val');
M_.param_names = char(M_.param_names, 'std_nu_val');
M_.param_names_tex = char(M_.param_names_tex, 'std\_nu\_val');
M_.param_names_long = char(M_.param_names_long, 'std_nu_val');
M_.param_names = char(M_.param_names, 'rho_a_val');
M_.param_names_tex = char(M_.param_names_tex, 'rho\_a\_val');
M_.param_names_long = char(M_.param_names_long, 'rho_a_val');
M_.param_names = char(M_.param_names, 'std_a_val');
M_.param_names_tex = char(M_.param_names_tex, 'std\_a\_val');
M_.param_names_long = char(M_.param_names_long, 'std_a_val');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 2;
M_.endo_nbr = 11;
M_.param_nbr = 9;
M_.orig_endo_nbr = 11;
M_.aux_vars = [];
M_.Sigma_e = zeros(2, 2);
M_.Correlation_matrix = eye(2, 2);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = 1;
M_.det_shocks = [];
options_.linear = 1;
options_.block=0;
options_.bytecode=0;
options_.use_dll=0;
M_.hessian_eq_zero = 1;
erase_compiled_function('nk_fullsystem_static');
erase_compiled_function('nk_fullsystem_dynamic');
M_.orig_eq_nbr = 11;
M_.eq_nbr = 11;
M_.ramsey_eq_nbr = 0;
M_.lead_lag_incidence = [
 0 3 0;
 0 4 14;
 0 5 0;
 0 6 0;
 0 7 0;
 0 8 0;
 0 9 15;
 0 10 0;
 0 11 0;
 1 12 0;
 2 13 0;]';
M_.nstatic = 7;
M_.nfwrd   = 2;
M_.npred   = 2;
M_.nboth   = 0;
M_.nsfwrd   = 2;
M_.nspred   = 2;
M_.ndynamic   = 4;
M_.equations_tags = {
};
M_.static_and_dynamic_models_differ = 0;
M_.exo_names_orig_ord = [1:2];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(11, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(2, 1);
M_.params = NaN(9, 1);
M_.NNZDerivatives = [33; -1; -1];
load parameters.mat
M_.params( 1 ) = lambda;
lambda_val = M_.params( 1 );
M_.params( 2 ) = beta;
beta_val = M_.params( 2 );
M_.params( 3 ) = varphi;
varphi_val = M_.params( 3 );
M_.params( 4 ) = phi_pi;
phi_pi_val = M_.params( 4 );
M_.params( 5 ) = LS;
LS_val = M_.params( 5 );
M_.params( 6 ) = rho_nu;
rho_nu_val = M_.params( 6 );
M_.params( 7 ) = std_nu;
std_nu_val = M_.params( 7 );
M_.params( 8 ) = rho_a;
rho_a_val = M_.params( 8 );
M_.params( 9 ) = std_a;
std_a_val = M_.params( 9 );
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = M_.params(7)^2;
M_.Sigma_e(2, 2) = M_.params(9)^2;
steady;
options_.irf = 50;
options_.nograph = 1;
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
save('nk_fullsystem_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('nk_fullsystem_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('nk_fullsystem_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('nk_fullsystem_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('nk_fullsystem_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('nk_fullsystem_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('nk_fullsystem_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
diary off
