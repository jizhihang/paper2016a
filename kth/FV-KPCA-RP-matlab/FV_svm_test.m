function  [predicted_label, accuracy, dec_values] = FV_svm_test(K, list_pac_te, dim, svm_type, FV_folder, svm_folder)

FV_dim =  K*dim*2;
n_samples_test = length(list_pac_te);
X_test = zeros(FV_dim,n_samples_test);
labels_test = zeros(n_samples_test,1);





%%


for i=1: n_samples_test
    
    
    person   = list_pac_te{i,1};
    action   = list_pac_te{i,2};
    act      = list_pac_te{i,4};
    
    load_FV =   strcat('./', FV_folder, '/FV_', person, '_', action, '_dim', num2str(dim),'.h5' );
    data_one_FV = hdf5info( char(load_FV) );
    FV_i = hdf5read(data_one_FV.GroupHierarchy.Datasets(1));
    
    X_test(:,i) = FV_i;
    labels_test(i) = act;
    
end


%% libSVM
if strcmp( svm_type, 'svm')
    load_svm_model = strcat( './', svm_folder, '/linear_kernel_svm_FV_pp', num2str(K), '.mat');
    load(load_svm_model, 'model');
    [predicted_label, accuracy, dec_values] = svmpredict(labels_test, X_test', model);
    
end

%% libLinear
if strcmp( svm_type, 'linear')
    load_svm_model = strcat( './svm_models_liblinear/linear_kernel_svm_FV_pp_K', num2str(K), '_dim', num2str(dim), '.mat')
    load(load_svm_model) % Loading  model obtained with libLinear
    sparse_X_test =  sparse(X_test');
    [predicted_label, accuracy, dec_values] = predict(labels_test,sparse_X_test , model);
end

