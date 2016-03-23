%NICTA && Server
clear all
close all
clc

dbstop error;
%dbstop in  get_universalGMM at 14


pc = 'wanda'; % uq wanda home

svm_type = 'linear'; %'svm';    %libsvm


if strcmp( pc, 'wanda')
    %VL
    run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');
    
    %Fisher Vector
    addpath('/home/johanna/toolbox/yael/matlab');
    
    %libSVM
    if strcmp( svm_type, 'libsvm')
        addpath('/home/johanna/toolbox/libsvm-3.20/matlab')
    end
    
    
    if strcmp( svm_type, 'linear')
        addpath('/home/johanna/toolbox/liblinear-2.1/matlab');
        
    end
    
    
    %Path for Original dataset
    path_dataset  = '/home/johanna/codes/datasets_codes/MissUniverse/';
    
    %This path is only to load the matrices that contain all the feature vectors
    %per video and their labels.
    path_features = '/home/johanna/codes/codes-git/paper2016a/trunk/miss_universe/features/features/';

end


if strcmp( pc, 'uq')
    %VL
    run('/home/johanna-uq/Toolbox/vlfeat-0.9.20/toolbox/vl_setup');
    
    %Fisher Vector
    addpath('/home/johanna-uq/Toolbox/yael/matlab');
    
    if strcmp( svm_type, 'libsvm')
        %libSVM
        addpath('/home/johanna-uq/Toolbox/libsvm-320/matlab');
    end
    
    
    if strcmp( svm_type, 'linear')
        %libLinear
        addpath('/home/johanna-uq/Toolbox/liblinear-2.1/matlab');
        
    end
    
    
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





prompt = 'K? ';
K = input(prompt);

%vec_K =  [1024 512 256 128];
%vec_K = [512];
%K = 128;
vec_c = [ 0.1 1 10 100];
%vec_c = [ 10 ] ;

n_segm = 4;

n_iterGMM = 10; % For GMM

MU_years = importdata('miss_universe_list.txt');

all_years = [  2010 2007 2003 2002 2001 ];

if  strcmp( svm_type, 'svm')
    s = 0;
    all_accuracy = zeros(length(all_years), length(vec_c) );
end

if  strcmp( svm_type, 'linear')
    s = 1; % L2-regularized L2-loss support vector classification (dual)
    all_accuracy = zeros(length(all_years), length(vec_c) );
end


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
    dim_FV = 2*dim*K*n_segm;
    create_folders_FV(FV_folder, svm_folder, GMM_folder);
    
    %get_universalGMM(path_dataset,  path_features, view, years_train,  K,  n_iterGMM, GMM_folder, run)
    %FV_MU_all_videos_seg(path_dataset, path_features, view, all_years, K,  GMM_folder, FV_folder, run, n_segm)
    
    
    
    for j = 1: length(vec_c)
        c = vec_c (j);
        
        if strcmp( svm_type, 'svm')
            params =  sprintf('-s %f -t 0 -c %f -q', s, c);
        end
        
        if strcmp( svm_type, 'linear')
            params =  sprintf('-s %f  -c %f -q', s, c);
        end
        
        
        
        %Training
        FV_train_rankSVM(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, svm_type, params, run);
        
        %Testing
        [predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim_FV, FV_folder, svm_folder, svm_type, run);
        AA = [predicted_output  labels_test];
        all_accuracy(i,j) = accuracy(1);
        
        
        [a real_order]  = sort(scores', 'descend');
        BB  = [ predicted_output n_labels_test];
        predicted_order = get_predicted_list(BB, n_countries);
        
    end
    
    
end


