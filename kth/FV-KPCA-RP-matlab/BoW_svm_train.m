function BoW_svm_train(K, list_pac_tr, dim, BoW_folder, svm_folder)

n_samples_train = length(list_pac_tr);
X_train = zeros(K,n_samples_train);
labels_train = zeros(n_samples_train,1);
    

for i=1: n_samples_train     
   
    
    person   = list_pac_tr{i,1};
    action   = list_pac_tr{i,2};
    act      = list_pac_tr{i,4};
    
    load_hist=  strcat('./', BoW_folder, '/pp_hist_', person, '_', action, '_dim',num2str(dim),  '.h5' );
    data_one_hist= hdf5info( char(load_hist) );
    hist_i = hdf5read(data_one_hist.GroupHierarchy.Datasets(1));
    hist_i = hist_i./norm(hist_i,1) ;

    X_train(:,i) = hist_i; 
    labels_train(i) = act;
    
end

K_train = inter_kernel(X_train,X_train);

 model = svmtrain(labels_train, [[1:size(K_train,1)]' K_train], '-t 4 -q ');
 save_svm_model = strcat( './', svm_folder, '/svm_models/inter_kernel_svm_BoW_pp', num2str(K), '_dim',num2str(dim), '.mat');
 save(save_svm_model, 'model', 'X_train');