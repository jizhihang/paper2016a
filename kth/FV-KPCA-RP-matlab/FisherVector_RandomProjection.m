clear all
clc
dbstop error;
%dbstop in FV_svm_train at 36;


%VL
run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');

%Fisher Vector
addpath('/home/johanna/toolbox/yael/matlab');

%General paths
path  = '~/codes/codes-git/paper2016a/trunk/kth/';


%svm_type
%svm_type = 'linear'; %liblinear
svm_type = 'svm';    %libsvm

%libLinear
if strcmp( svm_type, 'linear')
    addpath('/home/johanna/toolbox/liblinear-2.1/matlab');
    svm_folder = 'svm_models_liblinear';
end

%libSVM
if strcmp( svm_type, 'svm')
    addpath('/home/johanna/toolbox/libsvm-3.20/matlab')
    svm_folder = 'svm_models';
end


%% Kernel Type. For The KPCA-RP
%kernel_type = 'poly';
kernel_type = 'stein';

%%
% User Inputs
prompt = 'Random projected Dimensionality? ';
dim = input(prompt);


%dim = 4237; % After the random projection
%dim = 8475
%vec_K = [128 256 512 4000];
vec_K = [1024];


n_iterGMM = 10; % For GMM

actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;
load_sub_path_1 =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


people_test =  [ 2 3 5  6  7  8  9  10 22 ];
people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];



n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, #covs
[list_pac_tr total_num_covs_tr] = get_list( n_actions, path, all_people, actions, load_sub_path_1, people_train);
[list_pac_te total_num_covs_te] = get_list( n_actions, path, all_people, actions, load_sub_path_1, people_test);



for k =1:length(vec_K)
    
    K = vec_K(k)
    
    if strcmp( kernel_type, 'stein')
        
        FV_folder = strcat('FV_K', num2str(K));
        GMM_folder = 'universal_GMM';
        % This folder is obtained in KPCA-RP
        folder_pp = strcat( 'projected_points_dim', num2str(dim));
        
    end
    
    if strcmp( kernel_type, 'poly')
        
        FV_folder = strcat('FV_K', num2str(K),'_polyKernel');
        GMM_folder = 'universal_GMM_polyKernel';
        % This folder is obtained in KPCA-RP
        folder_pp = strcat( 'PolyKernel_projected_points_dim', num2str(dim));
        svm_folder = strcat(svm_folder, '_polyKernel');
        
    end
    
    %Create needed Folders
    %create_folders_FV(FV_folder, svm_folder, GMM_folder)
    
    % Get the Universal GMM
    %disp('GMM');
    %get_universalGMM(path, list_pac_tr, total_num_covs_tr, K, dim, n_iterGMM, GMM_folder, folder_pp);
    
    % Getting FV for Training Set and Testing Set
    %disp('Getting FV descriptors');
    %get_FV_descriptors(list_pac_tr, list_pac_te, K,path, dim, GMM_folder, FV_folder, folder_pp)
    
end


%% Train and Test with SVM


%% For libSVM Example

if  strcmp( svm_type, 'svm')
    vec_c = [ 0.1 1 10 100 1000 10000];
    all_accuracy = zeros(1, length(vec_c) );
    
    for j = 1: length(vec_c)
        c = vec_c (j);
        params_svm=  sprintf('-s 0 -t 0 -c %f -q', c)
        FV_svm_train(K, list_pac_tr, dim, svm_type, params_svm, FV_folder, svm_folder );
        [predicted_label, accuracy, dec_values] = FV_svm_test(K, list_pac_te, dim, svm_type, FV_folder, svm_folder);
        all_accuracy(j) = accuracy(1)
    end
    
end


%% For libLinear Example
% vec_c = [ 0.01 0.1 1 10];
% vec_s_linear = [0 1 2];
%
% all_accuracy = zeros(length(vec_s_linear), length(vec_c) );
%
% for i = 1: length(vec_s_linear)
%     for j = 1: length(vec_c)
%
%         c = vec_c (j);
%         s = vec_s_linear(i);
%         params_linear =  sprintf('-s %f -c %f -q', s, c)
%         FV_svm_train(K, list_pac_tr, dim, svm_type, params_linear);
%         [predicted_label, accuracy, dec_values] = FV_svm_test(K, list_pac_te, dim, svm_type);
%         all_accuracy(i,j) = accuracy(1)
%
%     end
% end






