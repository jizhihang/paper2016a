function  [predicted_label, accuracy, dec_values] = BoW_svm_test(K, list_pac_te, dim, BoW_folder, svm_folder)

load_svm_model = strcat( './', svm_folder, '/inter_kernel_svm_BoW_pp', num2str(K), '_dim',num2str(dim), '.mat');
load(load_svm_model); % Loading Model and X_train



n_samples_test = length(list_pac_te);
X_test = zeros(K,n_samples_test);
labels_test = zeros(n_samples_test,1);
    

for i=1: n_samples_test    
   
    
    person   = list_pac_te{i,1};
    action   = list_pac_te{i,2};
    act      = list_pac_te{i,4};
    
    load_hist =  strcat('./', BoW_folder, '/pp_hist_', person, '_', action, '_dim',num2str(dim),  '.h5' );
    data_one_hist= hdf5info( char(load_hist) );
    hist_i = hdf5read(data_one_hist.GroupHierarchy.Datasets(1));
    hist_i = hist_i./norm(hist_i,1) ;
    
    X_test(:,i) = hist_i; 
    labels_test(i) = act;
    
end

 K_test = inter_kernel(X_test,X_train);
 [predicted_label, accuracy, dec_values] = svmpredict(labels_test,[[1:size(K_test,1)]' K_test], model);