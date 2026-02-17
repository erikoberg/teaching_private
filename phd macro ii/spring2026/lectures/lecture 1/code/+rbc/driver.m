%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

clearvars -global
clear_persistent_variables(fileparts(which('dynare')), false)
tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info
options_ = [];
M_.fname = 'rbc';
M_.dynare_version = '6.5';
oo_.dynare_version = '6.5';
options_.dynare_version = '6.5';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(1,1);
M_.exo_names_tex = cell(1,1);
M_.exo_names_long = cell(1,1);
M_.exo_names(1) = {'e'};
M_.exo_names_tex(1) = {'e'};
M_.exo_names_long(1) = {'e'};
M_.endo_names = cell(8,1);
M_.endo_names_tex = cell(8,1);
M_.endo_names_long = cell(8,1);
M_.endo_names(1) = {'ahat'};
M_.endo_names_tex(1) = {'ahat'};
M_.endo_names_long(1) = {'ahat'};
M_.endo_names(2) = {'yhat'};
M_.endo_names_tex(2) = {'yhat'};
M_.endo_names_long(2) = {'yhat'};
M_.endo_names(3) = {'nhat'};
M_.endo_names_tex(3) = {'nhat'};
M_.endo_names_long(3) = {'nhat'};
M_.endo_names(4) = {'khat'};
M_.endo_names_tex(4) = {'khat'};
M_.endo_names_long(4) = {'khat'};
M_.endo_names(5) = {'chat'};
M_.endo_names_tex(5) = {'chat'};
M_.endo_names_long(5) = {'chat'};
M_.endo_names(6) = {'ihat'};
M_.endo_names_tex(6) = {'ihat'};
M_.endo_names_long(6) = {'ihat'};
M_.endo_names(7) = {'what'};
M_.endo_names_tex(7) = {'what'};
M_.endo_names_long(7) = {'what'};
M_.endo_names(8) = {'rhat'};
M_.endo_names_tex(8) = {'rhat'};
M_.endo_names_long(8) = {'rhat'};
M_.endo_partitions = struct();
M_.param_names = cell(10,1);
M_.param_names_tex = cell(10,1);
M_.param_names_long = cell(10,1);
M_.param_names(1) = {'alpha_val'};
M_.param_names_tex(1) = {'alpha\_val'};
M_.param_names_long(1) = {'alpha_val'};
M_.param_names(2) = {'beta_val'};
M_.param_names_tex(2) = {'beta\_val'};
M_.param_names_long(2) = {'beta_val'};
M_.param_names(3) = {'delta_val'};
M_.param_names_tex(3) = {'delta\_val'};
M_.param_names_long(3) = {'delta_val'};
M_.param_names(4) = {'theta_val'};
M_.param_names_tex(4) = {'theta\_val'};
M_.param_names_long(4) = {'theta_val'};
M_.param_names(5) = {'varphi_val'};
M_.param_names_tex(5) = {'varphi\_val'};
M_.param_names_long(5) = {'varphi_val'};
M_.param_names(6) = {'std_a_val'};
M_.param_names_tex(6) = {'std\_a\_val'};
M_.param_names_long(6) = {'std_a_val'};
M_.param_names(7) = {'rho_a_val'};
M_.param_names_tex(7) = {'rho\_a\_val'};
M_.param_names_long(7) = {'rho_a_val'};
M_.param_names(8) = {'R_ss_val'};
M_.param_names_tex(8) = {'R\_ss\_val'};
M_.param_names_long(8) = {'R_ss_val'};
M_.param_names(9) = {'CY_ss_val'};
M_.param_names_tex(9) = {'CY\_ss\_val'};
M_.param_names_long(9) = {'CY_ss_val'};
M_.param_names(10) = {'IY_ss_val'};
M_.param_names_tex(10) = {'IY\_ss\_val'};
M_.param_names_long(10) = {'IY_ss_val'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 8;
M_.param_nbr = 10;
M_.orig_endo_nbr = 8;
M_.aux_vars = [];
M_.Sigma_e = zeros(1, 1);
M_.Correlation_matrix = eye(1, 1);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = [];
M_.surprise_shocks = [];
M_.learnt_shocks = [];
M_.learnt_endval = [];
M_.heteroskedastic_shocks.Qvalue_orig = [];
M_.heteroskedastic_shocks.Qscale_orig = [];
M_.matched_irfs = {};
M_.matched_irfs_weights = {};
options_.linear = true;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
options_.ramsey_policy = false;
options_.discretionary_policy = false;
M_.nonzero_hessian_eqs = [];
M_.hessian_eq_zero = isempty(M_.nonzero_hessian_eqs);
M_.eq_nbr = 8;
M_.ramsey_orig_eq_nbr = 0;
M_.ramsey_orig_endo_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 1;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 1;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 1;
M_.lead_lag_incidence = [
 1 4 0;
 0 5 0;
 0 6 0;
 2 7 0;
 0 8 12;
 3 9 0;
 0 10 0;
 0 11 13;]';
M_.nstatic = 3;
M_.nfwrd   = 2;
M_.npred   = 3;
M_.nboth   = 0;
M_.nsfwrd   = 2;
M_.nspred   = 3;
M_.ndynamic   = 5;
M_.dynamic_tmp_nbr = [0; 0; 0; 0; ];
M_.equations_tags = {
  1 , 'name' , 'ahat' ;
  2 , 'name' , 'what' ;
  3 , 'name' , 'chat' ;
  4 , 'name' , 'yhat' ;
  5 , 'name' , '5' ;
  6 , 'name' , 'khat' ;
  7 , 'name' , 'rhat' ;
  8 , 'name' , '8' ;
};
M_.mapping.ahat.eqidx = [1 5 7 8 ];
M_.mapping.yhat.eqidx = [4 5 ];
M_.mapping.nhat.eqidx = [2 5 7 8 ];
M_.mapping.khat.eqidx = [5 6 7 8 ];
M_.mapping.chat.eqidx = [2 3 4 ];
M_.mapping.ihat.eqidx = [4 6 ];
M_.mapping.what.eqidx = [2 8 ];
M_.mapping.rhat.eqidx = [3 7 ];
M_.mapping.e.eqidx = [1 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.block_structure.time_recursive = false;
M_.block_structure.block(1).Simulation_Type = 1;
M_.block_structure.block(1).endo_nbr = 1;
M_.block_structure.block(1).mfs = 1;
M_.block_structure.block(1).equation = [ 1];
M_.block_structure.block(1).variable = [ 1];
M_.block_structure.block(1).is_linear = true;
M_.block_structure.block(1).NNZDerivatives = 2;
M_.block_structure.block(1).bytecode_jacob_cols_to_sparse = [1 2 ];
M_.block_structure.block(2).Simulation_Type = 8;
M_.block_structure.block(2).endo_nbr = 7;
M_.block_structure.block(2).mfs = 5;
M_.block_structure.block(2).equation = [ 2 5 8 4 6 3 7];
M_.block_structure.block(2).variable = [ 7 2 3 6 4 5 8];
M_.block_structure.block(2).is_linear = true;
M_.block_structure.block(2).NNZDerivatives = 18;
M_.block_structure.block(2).bytecode_jacob_cols_to_sparse = [2 3 0 0 6 7 8 9 10 14 15 ];
M_.block_structure.block(1).g1_sparse_rowval = int32([]);
M_.block_structure.block(1).g1_sparse_colval = int32([]);
M_.block_structure.block(1).g1_sparse_colptr = int32([]);
M_.block_structure.block(2).g1_sparse_rowval = int32([3 3 1 2 5 2 1 2 3 5 1 2 4 5 4 4 ]);
M_.block_structure.block(2).g1_sparse_colval = int32([2 3 6 6 6 7 8 8 8 8 9 9 9 10 14 15 ]);
M_.block_structure.block(2).g1_sparse_colptr = int32([1 1 2 3 3 3 6 7 11 14 15 15 15 15 16 17 ]);
M_.block_structure.variable_reordered = [ 1 7 2 3 6 4 5 8];
M_.block_structure.equation_reordered = [ 1 2 5 8 4 6 3 7];
M_.block_structure.incidence(1).lead_lag = -1;
M_.block_structure.incidence(1).sparse_IM = [
 1 1;
 6 4;
 6 6;
];
M_.block_structure.incidence(2).lead_lag = 0;
M_.block_structure.incidence(2).sparse_IM = [
 1 1;
 2 3;
 2 5;
 2 7;
 3 5;
 4 2;
 4 5;
 4 6;
 5 1;
 5 2;
 5 3;
 5 4;
 6 4;
 7 1;
 7 3;
 7 4;
 7 8;
 8 1;
 8 3;
 8 4;
 8 7;
];
M_.block_structure.incidence(3).lead_lag = 1;
M_.block_structure.incidence(3).sparse_IM = [
 3 5;
 3 8;
];
M_.block_structure.dyn_tmp_nbr = 0;
M_.state_var = [1 6 4 ];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(8, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(1, 1);
M_.params = NaN(10, 1);
M_.endo_trends = struct('deflator', cell(8, 1), 'log_deflator', cell(8, 1), 'growth_factor', cell(8, 1), 'log_growth_factor', cell(8, 1));
M_.NNZDerivatives = [27; 0; -1; ];
M_.dynamic_g1_sparse_rowval = int32([1 6 6 1 5 7 8 4 5 2 5 7 8 5 6 7 8 2 3 4 4 2 8 7 3 3 1 ]);
M_.dynamic_g1_sparse_colval = int32([1 4 6 9 9 9 9 10 10 11 11 11 11 12 12 12 12 13 13 13 14 15 15 16 21 24 25 ]);
M_.dynamic_g1_sparse_colptr = int32([1 2 2 2 3 3 4 4 4 8 10 14 18 21 22 24 25 25 25 25 25 26 26 26 27 28 ]);
M_.dynamic_g2_sparse_indices = int32([]);
M_.lhs = {
'ahat'; 
'what'; 
'chat'; 
'yhat'; 
'yhat'; 
'khat'; 
'rhat'; 
'what'; 
};
M_.static_tmp_nbr = [0; 0; 0; 0; ];
M_.block_structure_stat.block(1).Simulation_Type = 3;
M_.block_structure_stat.block(1).endo_nbr = 1;
M_.block_structure_stat.block(1).mfs = 1;
M_.block_structure_stat.block(1).equation = [ 1];
M_.block_structure_stat.block(1).variable = [ 1];
M_.block_structure_stat.block(2).Simulation_Type = 6;
M_.block_structure_stat.block(2).endo_nbr = 7;
M_.block_structure_stat.block(2).mfs = 7;
M_.block_structure_stat.block(2).equation = [ 2 3 4 5 6 7 8];
M_.block_structure_stat.block(2).variable = [ 7 8 5 2 6 3 4];
M_.block_structure_stat.variable_reordered = [ 1 7 8 5 2 6 3 4];
M_.block_structure_stat.equation_reordered = [ 1 2 3 4 5 6 7 8];
M_.block_structure_stat.incidence.sparse_IM = [
 1 1;
 2 3;
 2 5;
 2 7;
 3 8;
 4 2;
 4 5;
 4 6;
 5 1;
 5 2;
 5 3;
 5 4;
 6 4;
 6 6;
 7 1;
 7 3;
 7 4;
 7 8;
 8 1;
 8 3;
 8 4;
 8 7;
];
M_.block_structure_stat.tmp_nbr = 0;
M_.block_structure_stat.block(1).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(1).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(1).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(2).g1_sparse_rowval = int32([1 7 2 6 1 3 3 4 3 5 1 4 6 7 4 5 6 7 ]);
M_.block_structure_stat.block(2).g1_sparse_colval = int32([1 1 2 2 3 3 4 4 5 5 6 6 6 6 7 7 7 7 ]);
M_.block_structure_stat.block(2).g1_sparse_colptr = int32([1 3 5 7 9 11 15 19 ]);
M_.static_g1_sparse_rowval = int32([1 5 7 8 4 5 2 5 7 8 5 6 7 8 2 4 4 6 2 8 3 7 ]);
M_.static_g1_sparse_colval = int32([1 1 1 1 2 2 3 3 3 3 4 4 4 4 5 5 6 6 7 7 8 8 ]);
M_.static_g1_sparse_colptr = int32([1 5 7 11 15 17 19 21 23 ]);
load parameters.mat
M_.params(1) = alpha;
alpha_val = M_.params(1);
M_.params(2) = beta;
beta_val = M_.params(2);
M_.params(3) = delta;
delta_val = M_.params(3);
M_.params(4) = theta;
theta_val = M_.params(4);
M_.params(5) = varphi;
varphi_val = M_.params(5);
M_.params(6) = std_a;
std_a_val = M_.params(6);
M_.params(7) = rho_a;
rho_a_val = M_.params(7);
M_.params(8) = R_ss;
R_ss_val = M_.params(8);
M_.params(9) = CY_ss;
CY_ss_val = M_.params(9);
M_.params(10) = IY_ss;
IY_ss_val = M_.params(10);
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = M_.params(6)^2;
steady;
options_.hp_filter = 1600;
options_.irf = 100;
options_.nograph = true;
options_.order = 1;
var_list_ = {};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'oo_recursive_', '-append');
end
if exist('options_mom_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'rbc_results.mat'], 'options_mom_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
