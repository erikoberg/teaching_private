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
M_.fname = 'rbc_utilization';
M_.dynare_version = '4.5.1';
oo_.dynare_version = '4.5.1';
options_.dynare_version = '4.5.1';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('rbc_utilization.log');
M_.exo_names = 'e';
M_.exo_names_tex = 'e';
M_.exo_names_long = 'e';
M_.endo_names = 'ahat';
M_.endo_names_tex = 'ahat';
M_.endo_names_long = 'ahat';
M_.endo_names = char(M_.endo_names, 'yhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'yhat');
M_.endo_names_long = char(M_.endo_names_long, 'yhat');
M_.endo_names = char(M_.endo_names, 'nhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'nhat');
M_.endo_names_long = char(M_.endo_names_long, 'nhat');
M_.endo_names = char(M_.endo_names, 'khat');
M_.endo_names_tex = char(M_.endo_names_tex, 'khat');
M_.endo_names_long = char(M_.endo_names_long, 'khat');
M_.endo_names = char(M_.endo_names, 'kstarhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'kstarhat');
M_.endo_names_long = char(M_.endo_names_long, 'kstarhat');
M_.endo_names = char(M_.endo_names, 'chat');
M_.endo_names_tex = char(M_.endo_names_tex, 'chat');
M_.endo_names_long = char(M_.endo_names_long, 'chat');
M_.endo_names = char(M_.endo_names, 'ihat');
M_.endo_names_tex = char(M_.endo_names_tex, 'ihat');
M_.endo_names_long = char(M_.endo_names_long, 'ihat');
M_.endo_names = char(M_.endo_names, 'what');
M_.endo_names_tex = char(M_.endo_names_tex, 'what');
M_.endo_names_long = char(M_.endo_names_long, 'what');
M_.endo_names = char(M_.endo_names, 'rhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'rhat');
M_.endo_names_long = char(M_.endo_names_long, 'rhat');
M_.endo_names = char(M_.endo_names, 'deltahat');
M_.endo_names_tex = char(M_.endo_names_tex, 'deltahat');
M_.endo_names_long = char(M_.endo_names_long, 'deltahat');
M_.endo_names = char(M_.endo_names, 'uhat');
M_.endo_names_tex = char(M_.endo_names_tex, 'uhat');
M_.endo_names_long = char(M_.endo_names_long, 'uhat');
M_.endo_partitions = struct();
M_.param_names = 'alpha_val';
M_.param_names_tex = 'alpha\_val';
M_.param_names_long = 'alpha_val';
M_.param_names = char(M_.param_names, 'beta_val');
M_.param_names_tex = char(M_.param_names_tex, 'beta\_val');
M_.param_names_long = char(M_.param_names_long, 'beta_val');
M_.param_names = char(M_.param_names, 'delta0_val');
M_.param_names_tex = char(M_.param_names_tex, 'delta0\_val');
M_.param_names_long = char(M_.param_names_long, 'delta0_val');
M_.param_names = char(M_.param_names, 'eta1_val');
M_.param_names_tex = char(M_.param_names_tex, 'eta1\_val');
M_.param_names_long = char(M_.param_names_long, 'eta1_val');
M_.param_names = char(M_.param_names, 'eta2_val');
M_.param_names_tex = char(M_.param_names_tex, 'eta2\_val');
M_.param_names_long = char(M_.param_names_long, 'eta2_val');
M_.param_names = char(M_.param_names, 'theta_val');
M_.param_names_tex = char(M_.param_names_tex, 'theta\_val');
M_.param_names_long = char(M_.param_names_long, 'theta_val');
M_.param_names = char(M_.param_names, 'varphi_val');
M_.param_names_tex = char(M_.param_names_tex, 'varphi\_val');
M_.param_names_long = char(M_.param_names_long, 'varphi_val');
M_.param_names = char(M_.param_names, 'std_a_val');
M_.param_names_tex = char(M_.param_names_tex, 'std\_a\_val');
M_.param_names_long = char(M_.param_names_long, 'std_a_val');
M_.param_names = char(M_.param_names, 'rho_a_val');
M_.param_names_tex = char(M_.param_names_tex, 'rho\_a\_val');
M_.param_names_long = char(M_.param_names_long, 'rho_a_val');
M_.param_names = char(M_.param_names, 'R_ss_val');
M_.param_names_tex = char(M_.param_names_tex, 'R\_ss\_val');
M_.param_names_long = char(M_.param_names_long, 'R_ss_val');
M_.param_names = char(M_.param_names, 'CY_ss_val');
M_.param_names_tex = char(M_.param_names_tex, 'CY\_ss\_val');
M_.param_names_long = char(M_.param_names_long, 'CY_ss_val');
M_.param_names = char(M_.param_names, 'IY_ss_val');
M_.param_names_tex = char(M_.param_names_tex, 'IY\_ss\_val');
M_.param_names_long = char(M_.param_names_long, 'IY_ss_val');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 11;
M_.param_nbr = 12;
M_.orig_endo_nbr = 11;
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
erase_compiled_function('rbc_utilization_static');
erase_compiled_function('rbc_utilization_dynamic');
M_.orig_eq_nbr = 11;
M_.eq_nbr = 11;
M_.ramsey_eq_nbr = 0;
M_.lead_lag_incidence = [
 1 5 0;
 0 6 0;
 0 7 0;
 2 8 0;
 0 9 0;
 0 10 16;
 3 11 0;
 0 12 0;
 0 13 17;
 0 14 0;
 4 15 0;]';
M_.nstatic = 5;
M_.nfwrd   = 2;
M_.npred   = 4;
M_.nboth   = 0;
M_.nsfwrd   = 2;
M_.nspred   = 4;
M_.ndynamic   = 6;
M_.equations_tags = {
};
M_.static_and_dynamic_models_differ = 0;
M_.exo_names_orig_ord = [1:1];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(11, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(1, 1);
M_.params = NaN(12, 1);
M_.NNZDerivatives = [35; -1; -1];
load parameters.mat
M_.params( 1 ) = alpha;
alpha_val = M_.params( 1 );
M_.params( 2 ) = beta;
beta_val = M_.params( 2 );
M_.params( 3 ) = delta0;
delta0_val = M_.params( 3 );
M_.params( 4 ) = eta1;
eta1_val = M_.params( 4 );
M_.params( 5 ) = eta2;
eta2_val = M_.params( 5 );
M_.params( 6 ) = theta;
theta_val = M_.params( 6 );
M_.params( 7 ) = varphi;
varphi_val = M_.params( 7 );
M_.params( 8 ) = std_a;
std_a_val = M_.params( 8 );
M_.params( 9 ) = rho_a;
rho_a_val = M_.params( 9 );
M_.params( 10 ) = R_ss;
R_ss_val = M_.params( 10 );
M_.params( 11 ) = CY_ss;
CY_ss_val = M_.params( 11 );
M_.params( 12 ) = IY_ss;
IY_ss_val = M_.params( 12 );
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = M_.params(8)^2;
steady;
options_.hp_filter = 1600;
options_.irf = 100;
options_.nograph = 1;
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
save('rbc_utilization_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('rbc_utilization_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('rbc_utilization_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('rbc_utilization_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('rbc_utilization_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('rbc_utilization_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('rbc_utilization_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
diary off
