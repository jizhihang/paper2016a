%NICTA && Server
clear all
close all
clc

%dbstop error;
%dbstop in  get_universalGMM at 14


pc = 'uq'; % uq wanda home

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
    
    
    %Path for Original dataset
    path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';
    
    %This path is only to load the matrices that contain all the feature vectors
    %per video and their labels.
    path_features = '/home/johanna-uq/codes/codes-git/paper2016a/trunk/miss_universe/features/features/';
end



if strcmp( pc, 'home')
    %VL
    run('/media/johanna/HD1T/Toolbox/vlfeat-0.9.20/toolbox/vl_setup');
    
    %Fisher Vector
    addpath('/media/johanna/HD1T/Toolbox/yael/matlab');
    
    %libSVM
    addpath('/media/johanna/HD1T/Toolbox/libsvm-3.20/matlab');
    
    
    %Path for Original dataset
    path_dataset  = '/media/johanna/HD1T/codes/datasets_codes/MissUniverse/';
    
    %This path is only to load the matrices that contain all the feature vectors
    %per video and their labels.
    path_features = '/media/johanna/HD1T/codes/codes-git/paper2016a/trunk/miss_universe/features/features/';
end






%vec_K =  [1024 512 256 128];
%vec_K = [512];
K = 2048;
vec_c = [ 0.1 1 10 100];
%vec_c = [ 10 ] ;
    
    
    
n_iterGMM = 10; % For GMM

MU_years = importdata('miss_universe_list.txt');

all_years = [  2010 2007 2003 2002 2001 ];


 all_accuracy = zeros(length(all_years), length(vec_c) );

for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
    %all_years = [ years_train years_test ];
    
    view = 1;
    dim = 14;
    
    GMM_folder = 'universal_GMM';
    svm_folder = 'svm_models'; 
    
         
         FV_folder = strcat('FV_K', num2str(K));
         dim_FV = 2*dim*K;
         create_folders_FV(FV_folder, svm_folder, GMM_folder);
         
         get_universalGMM(path_dataset,  path_features, view, years_train,  K,  n_iterGMM, GMM_folder, run)
         FV_MU_all_videos(path_dataset, path_features, view, all_years, K, GMM_folder, FV_folder, run)
   
    
    %top_n = 1;


        FV_folder = strcat('FV_K', num2str(K));
        dim_FV = 2*dim*K;
        for j = 1: length(vec_c)
            c = vec_c (j);
            
            params =  sprintf('-s 0 -t 0 -c %f -q', c);
            %FV_train(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, params, top_n);
            %[predicted_output, accuracy, dec_values, labels_test]  = FV_test(path_dataset, view, years_test, K, dim, dim_FV, FV_folder, svm_folder, top_n);
            
            %Training
            FV_train_rankSVM(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, params, run);
            
            %Testing
            [predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim_FV, FV_folder, svm_folder, run);
            AA = [predicted_output  labels_test];
            all_accuracy(i,j) = accuracy(1)
            
            
            [a real_order]  = sort(scores', 'descend'); 
            BB  = [ predicted_output n_labels_test]; 
            predicted_order = get_predicted_list(BB, n_countries);
            %all_mean_sq_error(k, j) = mean_sq_error(2);
            %[a1 best_3_predicted] = sort(predicted_output'); best_3_predicted(1:3)
            %[a2 best_3_real] = sort(labels_test'); best_3_real(1:3)
            
        end

end


