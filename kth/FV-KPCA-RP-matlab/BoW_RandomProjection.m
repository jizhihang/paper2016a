clear all
clc
dbstop error;
%dbstop in random_projection at 38;

%VL
run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');

%LIBSVM
addpath('/home/johanna/toolbox/libsvm-3.20/matlab')

%General Path
path  = '~/codes/codes-git/paper2016a/trunk/kth/';


% User Inputs
prompt = 'Random projected Dimensionality? ';
dim = input(prompt);


% Kernel Type. For The KPCA-RP
kernel_type = 'poly';
%kernel_type = 'stein';

num_iter = 10; %  forKmeans
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;

people_test =  [ 2 3 5  6  7  8  9  10 22 ];
people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];

load_sub_path_1 =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, #covs
[list_pac_tr total_num_covs_tr] = get_list( n_actions, path, all_people, actions, load_sub_path_1, people_train);
[list_pac_te total_num_covs_te] = get_list( n_actions, path, all_people, actions, load_sub_path_1, people_test);

%vec_K = [128 256 512 4000];
%vec_K = [512 4000 ];

vec_K = [1024];
all_accuracy = zeros(1,length(vec_K));
for k =1:length(vec_K)
    
    K = vec_K(k)
    
    %Create needed folders
    if strcmp( kernel_type, 'stein') 
    Kmeans_folder = 'Kmeans';
    BoW_folder = strcat('BoW_hist_K', num2str(K));
    svm_folder = 'svm_models'; 
    % This folder is obtained in KPCA-RP
    folder_pp = strcat( 'projected_points_dim', num2str(dim));    
    end
    
    if strcmp( kernel_type, 'poly') 
        Kmeans_folder = 'Kmeans_polyKernel';
        BoW_folder = strcat('BoW_hist_K', num2str(K), '_polyKernel');
        svm_folder = 'svm_models_polyKernel';
        % This folder is obtained in KPCA-RP
        folder_pp = strcat( 'PolyKernel_projected_points_dim', num2str(dim));    
    end
    
    create_folders(Kmeans_folder,BoW_folder, svm_folder)
    
    
    
    
    
    % Get Kmeans (Vocabulary)
    disp('Kmeans');
    get_Kmeans(path, list_pac_tr, total_num_covs_tr, K, dim, num_iter, Kmeans_folder, folder_pp)
    
    % Get Descriptors for Training and Testing Set
    disp('Getting Descriptors');
    get_descriptors_BoW(list_pac_tr,list_pac_te,K,path, dim, Kmeans_folder, BoW_folder, folder_pp)
    
    % Train and Test with SVM
    
    disp('Training and Testing with SVM classifier');
    
    BoW_svm_train(K, list_pac_tr, dim, BoW_folder, svm_folder);
    [predicted_label, accuracy, dec_values] = BoW_svm_test(K, list_pac_te, dim, BoW_folder, svm_folder);
    all_accuracy(k) = accuracy(1);
    
end

