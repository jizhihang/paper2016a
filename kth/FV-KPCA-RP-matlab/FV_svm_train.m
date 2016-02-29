function FV_svm_train(K, list_pac_tr, dim, svm_type, params)


FV_dim  =  K*dim*2;
n_samples_train = length(list_pac_tr);
X_train = zeros(FV_dim,n_samples_train);
labels_train = zeros(n_samples_train,1);


for i=1: n_samples_train
    
    
    person   = list_pac_tr{i,1};
    action   = list_pac_tr{i,2};
    act      = list_pac_tr{i,4};
    
    load_FV=  strcat('./FV_K', num2str(K), '/FV_', person, '_', action, '_dim', num2str(dim),'.h5' );
    data_one_hist= hdf5info( char(load_FV) );
    FV_i = hdf5read(data_one_hist.GroupHierarchy.Datasets(1));
    
    
    
    X_train(:,i) = FV_i;
    labels_train(i) = act;
    
end

data_train = X_train';

%% libSVM
if strcmp( svm_type, 'svm')
    svm_type
    model = svmtrain(labels_train, data_train, [params ]);
    save_svm_model = strcat( './svm_models/linear_kernel_svm_FV_pp', num2str(K), '.mat');
    save(save_svm_model, 'model');
end

%% libLinear
if strcmp( svm_type, 'linear')
    svm_type
    sparse_X_train =  sparse(X_train');
    model = train(labels_train, sparse_X_train, [params]);
    save_svm_model = strcat( './svm_models_liblinear/linear_kernel_svm_FV_pp_K', num2str(K), '_dim', num2str(dim), '.mat')
    save(save_svm_model, 'model');
end