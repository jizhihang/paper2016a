%NICTA && Server
clear all
close all
clc

dbstop error;
%dbstop in  get_universalGMM at 14


pc = 'wanda'; % uq wanda home
svm_type = 'linear'; %'svm';    %libsvm
[path_dataset path_features] = set_paths(pc, svm_type);

%% Parameters
%prompt = 'K? ';
%K = input(prompt);
K = 2048
vec_c = [ 0.1 1 10 100];
%vec_c =  [ 0.1 ];
n_iterGMM = 10; % For GMM


%MU_years = importdata('miss_universe_list.txt');

all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];


if  strcmp( svm_type, 'linear')
    s = 1; % L2-regularized L2-loss support vector classification (dual)
    all_accuracy = zeros(length(all_years), length(vec_c) );
end



info_results = cell(length( all_years), 5);

all_dec_values_FV = cell( length( all_years),1);

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
        
        if strcmp( svm_type, 'linear')
            params =  sprintf('-s %f  -c %f -q', s, c);
        end
        
        
        %FV_train(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, params, top_n);
        %[predicted_output, accuracy, dec_values, labels_test]  = FV_test(path_dataset, view, years_test, K, dim, dim_FV, FV_folder, svm_folder, top_n);
        
        %Training
        FV_train_rankSVM(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, svm_type, params, run);
        
        %Testing
        [predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim_FV, FV_folder, svm_folder, svm_type, run);
        AA = [predicted_output  labels_test];
        all_accuracy(i,j) = accuracy(1);
        
        all_dec_values_FV {i} =dec_values;

        
        [a real_order]  = sort(scores', 'descend');
        BB  = [ predicted_output n_labels_test];
        predicted_order = get_predicted_list(BB, n_countries);
        %all_mean_sq_error(k, j) = mean_sq_error(2);
        %[a1 best_3_predicted] = sort(predicted_output'); best_3_predicted(1:3)
        %[a2 best_3_real] = sort(labels_test'); best_3_real(1:3)
        
    end
    
    %Solo lo puedo hacer cuando vec_c tiene un solo elemento:
    %info_results_FV(i,1) = {accuracy(1)};
    %info_results_FV(i,2) = {real_order};
    %info_results_FV(i,3) = {predicted_order};
    %info_results_FV(i,4) = {labels_test};
    %info_results_FV(i,5) = {predicted_output };
    
end

%Save dec_values for best c & K
%save('dec_values_FV', 'all_dec_values_FV')
%save('info_results_FV', 'info_results_FV');

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
% % There 3 metrics for ndcg. opt can be 1,2 or 3.
% %I'm obtaining all of them 
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
   








