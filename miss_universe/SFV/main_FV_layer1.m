function main_FV_layer1(path_dataset, path_features, all_years, K, svm_type, vec_c, segm_length, n_iterGMM  )


all_accuracy = zeros(length(all_years), length(vec_c) );

view = 1;
dim = 14;

GMM_folder = 'universal_GMM';
svm_folder = 'svm_models';


FV_folder = strcat('FV_K', num2str(K));
% dim_FV = 2*dim*K*n_segm; AUN NO SE
create_folders_FV(FV_folder, svm_folder, GMM_folder);


%Leave-One-Out Cross-Validation. Leaving One Year Out
for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    %years_test  = all_years(i) ;
    
    %all_years = [ years_train years_test ];
    
    get_universalGMM(path_dataset,  path_features, view, years_train,  K,  n_iterGMM, GMM_folder, run);
    FV_layers_1  ( path_dataset, path_features, view, years_train, K,  GMM_folder, FV_folder, run, segm_length );
    dim_reduction( path_dataset, view, years_train,  FV_folder, run);
    

%     for j = 1: length(vec_c)
%         c = vec_c (j);
%         
%         if strcmp( svm_type, 'svm')
%             s = 0;
%             params =  sprintf('-s %f -t 0 -c %f -q', s, c);
%         end
%         
%         if strcmp( svm_type, 'linear')
%             s = 1; % L2-regularized L2-loss support vector classification (dual)
%             params =  sprintf('-s %f  -c %f -q', s, c);
%         end
%         
% 
%         %Training
%         FV_train_rankSVM(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, svm_type, params, run);
%         
%         %Testing
%         [predicted_output, accuracy, dec_values, labels_test,  n_labels_test, scores, n_countries]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim_FV, FV_folder, svm_folder, svm_type, run);
%         AA = [predicted_output  labels_test];
%         all_accuracy(i,j) = accuracy(1);
% 
%         [a real_order]  = sort(scores', 'descend');
%         BB  = [ predicted_output n_labels_test];
%         predicted_order = get_predicted_list(BB, n_countries);
%         
%     end
    
    
end


