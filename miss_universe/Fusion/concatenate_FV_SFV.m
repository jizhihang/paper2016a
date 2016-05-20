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
all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];


%Parameters
%vec_c = [ 0.1 1 10 100];
vec_c = [ 10 ] ;
K = 256;
view = 1;



% For SFV
FV_folder_ly1 = strcat('layer1/FV_K', num2str(K));
FV_folder_ly2 = strcat('layer2/FV_K', num2str(K));



% crear params using libSVM

if  strcmp( svm_type, 'linear')
    s = 1; % L2-regularized L2-loss support vector classification (dual)
    all_accuracy = zeros(length(all_years), length(vec_c) );
    %all_AP = zeros(length(all_years), length(vec_c) );
end



info_results = cell(length( all_years), 5);
all_predicted_order = cell(length( all_years),1);
all_real_order = cell(length( all_years),1);


my_path = pwd;
project_path = fileparts(my_path);

param.path_datasets = path_dataset;
param.project_path = project_path;
param.view = view;
param.K = K;

for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
   

    
    
    % Dimensionality of SFV
    load_rp_data = strcat(project_path, '/SFV/', FV_folder_ly1, '/pca_projection_data_run', num2str(run));
    load(char(load_rp_data),'NP');
    
    dim = NP;
    dim_FV = 2*dim*K;
    
    param.years_train = years_train;
    param.dim_FV = dim_FV;
    param.FV_folder_ly2 = FV_folder_ly2;
    param.run = run;


    
    
    for j = 1: length(vec_c)
        c = vec_c (j);
        
        if strcmp( svm_type, 'linear')
            params_svm =  sprintf('-s %f  -c %f -q', s, c);
        end
        
        
        
        %Training
        train_rankSVM_both(params, params_svm, svm_folder, svm_type);
        
        %Testing
        %[predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim_FV, FV_folder_ly2, svm_folder, svm_type, run);
        %AA = [predicted_output  labels_test];
        %all_accuracy(i,j) = accuracy(1);
        
    
        
        
        %[a real_order]  = sort(scores', 'descend');
        %BB  = [ predicted_output n_labels_test];
        %predicted_order = get_predicted_list(BB, n_countries);
       
        
    end
    
% Solo lo puedo hacer cuando vec_c tiene un solo elemento:
%     all_predicted_order(i) = {predicted_order};
%     all_real_order(i) = {real_order};
%     
%     info_results_SFV(i,1) = {accuracy(1)};
%     info_results_SFV(i,2) = {real_order};
%     info_results_SFV(i,3) = {predicted_order};
%     info_results_SFV(i,4) = {labels_test};
%     info_results_SFV(i,5) = {predicted_output };
%     
    
end




%To visualise
%all_predicted_order{i}

% disp('Top @ p = length(real)')
% all_ndcg = [];
% for m=1:length( all_years)
% info_results{m,1}; 
% real= info_results{m,2}; 
% pred=info_results{m,3};
% p = length(real);
% real_scores = p:-1:1; %pred_scores = zeros(1,p);
% 
% k = p;
% for v=1:p
%     pred_scores(v) = real_scores(find(real==pred(v))); 
% end
% 
% c_ndcg = [ ndcg(pred_scores,real_scores,k, 1) ndcg(pred_scores,real_scores,k, 2) ndcg(pred_scores,real_scores,k, 3)];
% all_ndcg = [all_ndcg;c_ndcg];
% end
% all_ndcg = all_ndcg*100
% mean(all_ndcg)


% % Top:
% 
% top_k = 1; %1 or 3 or 5
% acc = 0;
% for m =1:length( all_years)
%     info_results{m,1};real= info_results{m,2};pred=info_results{m,3};
%     winner = real(1);
%     top = pred(1:top_k);
%     acc = acc + length(find(top ==winner));
%     %disp('**************')
%     %pause
% end
% 
% acc = acc/ length( all_years)
   






