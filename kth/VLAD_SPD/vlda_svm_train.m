function vlda_svm_train(K, dim, list_pac_tr)


dim_spdvec  = dim*( dim + 1 )/2;
dim_vlad = K * dim_spdvec;

n_samples_train = length(list_pac_tr);
X_train = zeros(dim_vlad,n_samples_train);
labels_train = zeros(n_samples_train,1);
    

for i=1: n_samples_train     
   
    
    person   = list_pac_tr{i,1};
    action   = list_pac_tr{i,2};
    load_vlad=  strcat('./vlad/vlad_',person, '_', action, '.h5' );
    data_one_vlad= hdf5info( char(load_vlad) );
    vlad_i = hdf5read(data_one_vlad.GroupHierarchy.Datasets(1));
    vlad_i = vec(vlad_i);
    % power "normalisation"
    vlad_i = sign(vlad_i) .* sqrt(abs(vlad_i));
    %L2 normalization 
    vlad_i = vlad_i / sqrt(vlad_i'*vlad_i);
    
    
    X_train(:,i) = vlad_i; 
    labels_train(i) = find( strncmp(actions, action, length(action)) );
    labels_train(i) 
end


 data_train = X_train';
 model = svmtrain(labels_train, data_train, ['-s 0 -t 0 -b 1' ]);
 save_svm_model =strcat( './svm_models/linear_svm_vlad.mat')
 save(save_svm_model, 'model');