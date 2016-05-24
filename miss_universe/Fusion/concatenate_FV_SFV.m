% UQ && Server (WANDA) && Home
clear all
close all
clc

dbstop error;
dbstop in train_rankSVM_both at 76

%%Setting paths for libs and features and original dataset
pc = 'wanda'; % uq wanda home
svm_type = 'linear'; %'svm';    %libsvm
[path_dataset path_features] = set_paths(pc, svm_type);
all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];


%Parameters
%vec_c = [ 0.1 1 10 100];
%vec_c = [ 10 ] ;
prompt = 'c? ';
c = input(prompt);
K = 1024;
view = 1;



% For SFV
FV_folder_ly1 = strcat('layer1/FV_K', num2str(K));
FV_folder_ly2 = strcat('layer2/FV_K', num2str(K));

%For FV
FV_folder = strcat('FV_K', num2str(K));



% crear params using libSVM

if  strcmp( svm_type, 'linear')
    s = 1; % L2-regularized L2-loss support vector classification (dual)
    all_accuracy = zeros(length(all_years), 1 ); %Only one value of c
    %all_AP = zeros(length(all_years), length(vec_c) );
end



info_results = cell(length( all_years), 3);
all_predicted_order = cell(length( all_years),1);
all_real_order = cell(length( all_years),1);


my_path = pwd;
project_path = fileparts(my_path);

params.path_dataset = path_dataset;
params.project_path = project_path;
params.FV_folder_ly2 = FV_folder_ly2;
params.FV_folder = FV_folder;


params.view = view;
params.K = K;

for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
    
    
    
    
    % Dimensionality of SFV
    %load_rp_data = strcat(project_path, '/SFV/', FV_folder_ly1, '/pca_projection_data_run', num2str(run));
    %load(char(load_rp_data),'NP');
    
    NP = 14; % I reduced the dimensionality to same as original feature descriptors
    dim = NP;
    dim_SFV = 2*dim*K;
    dim_FV = 2*14*K;
    
    params.years_train = years_train;
    params.years_test = years_test;
    
    params.dim_SFV = dim_SFV;
    params.dim_FV  = dim_FV;
    
    params.run = run;
    
    if strcmp( svm_type, 'linear')
        params_svm =  sprintf('-s %f  -c %f -q', s, c);
    end
    
    %Reducing dim
    %reduce_dimensionality(params);
    
    %Training
    train_rankSVM_both(params, params_svm, svm_type);
    
    %Testing
    [predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = test_rankSVM_both(params,  svm_type);
    AA = [predicted_output  labels_test];
    all_accuracy(i,1) = accuracy(1);
    
    
    
    
    [a real_order]  = sort(scores', 'descend');
    BB  = [ predicted_output n_labels_test];
    predicted_order = get_predicted_list(BB, n_countries);
    
    
    % Solo lo puedo hacer cuando vec_c tiene un solo elemento:
    all_predicted_order(i) = {predicted_order};
    all_real_order(i) = {real_order};
    
    info_results(i,1) = {accuracy(1)};
    info_results(i,2) = {real_order};
    info_results(i,3) = {predicted_order};
    
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







