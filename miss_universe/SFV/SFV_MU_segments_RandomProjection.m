% UQ && Server (WANDA) && Home
clear all
close all
clc

dbstop error;
%dbstop in  get_universalGMM at 14
%dbstop in FV_layers_1 at 89
%dbstop in dim_reduction at 48

%%Setting paths for libs and features and original dataset
pc = 'wanda'; % uq wanda home
svm_type = 'linear'; %'svm';    %libsvm
[path_dataset path_features] = set_paths(pc, svm_type);

%MU_years = importdata('miss_universe_list.txt');

%all_years = [  2010 2007 2003 2002 2001 ];
all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];


prompt = 'K? ';
K = input(prompt);
%K = 1024;
view = 1;

%Parameters
vec_c = [ 0.1 1 10 100];
%vec_c = [ 10 ] ;

segm_length = 5;
n_iterGMM = 10; % For GMM


FV_folder_ly1 = strcat('layer1/FV_K', num2str(K));
red_FV_folder = strcat('layer1/red_FV_K', num2str(K));
GMM_folder_1 = 'layer1/universal_GMM';
create_folders_FV(FV_folder_ly1, red_FV_folder, GMM_folder_1);



GMM_folder_2 = 'layer2/universal_GMM';
svm_folder = 'layer2/svm_models';
FV_folder_ly2 = strcat('layer2/FV_K', num2str(K));
create_folders_FV_ly2(FV_folder_ly2, svm_folder, GMM_folder_2);



main_FV_layer1_RandomProjection(path_dataset, path_features, all_years, K, segm_length, n_iterGMM, FV_folder_ly1, red_FV_folder, GMM_folder_1  );
main_FV_layer2(path_dataset, all_years, K,  n_iterGMM, FV_folder_ly1, red_FV_folder, FV_folder_ly2, GMM_folder_2)



% crear params using libSVM

if  strcmp( svm_type, 'linear')
    s = 1; % L2-regularized L2-loss support vector classification (dual)
    all_accuracy = zeros(length(all_years), length(vec_c) );
end


for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
    
    load_rp_data = strcat('./', FV_folder_ly1, '/pca_projection_data_run', num2str(run));
    load(char(load_rp_data),'NP');
    
    dim = NP;
    dim_FV = 2*dim*K;
    
    
    for j = 1: length(vec_c)
        c = vec_c (j);
        
        
        if strcmp( svm_type, 'linear')
            params =  sprintf('-s %f  -c %f -q', s, c);
        end
        
        
        
        %Training
        FV_train_rankSVM(path_dataset, view, years_train, K, dim_FV, FV_folder_ly2, svm_folder, svm_type, params, run)
        
        %Testing
        [predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim_FV, FV_folder_ly2, svm_folder, svm_type, run);
        AA = [predicted_output  labels_test];
        all_accuracy(i,j) = accuracy(1);
        
        
        [a real_order]  = sort(scores', 'descend');
        BB  = [ predicted_output n_labels_test];
        predicted_order = get_predicted_list(BB, n_countries);
        
    end
    
    
    
end








