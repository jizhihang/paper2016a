%NICTA && Server
clear all
close all
clc

%dbstop error;
%dbstop in  get_universalGMM at 14


pc = 'uq';

if strcmp( pc, 'wanda')
%VL
run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');

%Fisher Vector
addpath('/home/johanna/toolbox/yael/matlab');

%libSVM
addpath('/home/johanna/toolbox/libsvm-3.20/matlab')

end


if strcmp( pc, 'uq')
 %VL
run('/home/johanna-uq/Toolbox/vlfeat-0.9.20/toolbox/vl_setup');   

%Fisher Vector
addpath('/home/johanna-uq/Toolbox/yael/matlab');

%libSVM
addpath('/home/johanna-uq/Toolbox/libsvm-320/matlab');
end



%Path for Original dataset
path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';

%This path is only to load the matrices that contain all the feature vectors
%per video and their labels.
path_features = '/home/johanna-uq/codes/codes-git/paper2016a/trunk/miss_universe/features/features/';

%vec_K =  [1024 512 256 128];
vec_K = [256];
n_iterGMM = 10; % For GMM

MU_years = importdata('miss_universe_list.txt');

all_years = [  2010 2007 2002 2001 ];

for i = 1: length( all_years)

years_train  =  all_years;
years_train(i) = [];
years_test  = all_years(i) ;

%all_years = [ years_train years_test ];

view = 1;
dim = 14;

GMM_folder = 'universal_GMM';
svm_folder = 'svr_models'; %Support Vector Regression

%  for k =1:length(vec_K)
%      
%      K = vec_K(k)
%      
%      FV_folder = strcat('FV_K', num2str(K));
%      dim_FV = 2*dim*K;
%      create_folders_FV(FV_folder, svm_folder, GMM_folder);
%      
%      get_universalGMM(path_dataset,  path_features, view, years_train,  K,  n_iterGMM, GMM_folder)
%      FV_MU_all_videos(path_dataset, path_features, view, all_years, K, dim, GMM_folder, FV_folder)
% %     
%  end


%vec_c = [ 0.1 1 10 100 1000 10000];
vec_c = [ 1 ] ;

all_mean_sq_error = zeros(length(vec_K), length(vec_c) );

top_n = 1;
 for k =1:length(vec_K)
     
     
     K = vec_K(k)
     FV_folder = strcat('FV_K', num2str(K));
     dim_FV = 2*dim*K;
     for j = 1: length(vec_c)
         c = vec_c (j);
         
         params =  sprintf('-s 0 -t 0 -c %f -q', c);
         FV_train(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, params, top_n);
         [predicted_output, accuracy, dec_values, labels_test]  = FV_test(path_dataset, view, years_test, K, dim, dim_FV, FV_folder, svm_folder, top_n);
         [predicted_output' ; labels_test']
         %all_mean_sq_error(k, j) = mean_sq_error(2);
         %[a1 best_3_predicted] = sort(predicted_output'); best_3_predicted(1:3)
         %[a2 best_3_real] = sort(labels_test'); best_3_real(1:3)
         
     end
     
 end
 
end
 
 
