function  [predicted_label, accuracy, prob_estimates] = vlda_svm_test(K, dim, list_pac_te)

load_svm_model =strcat( './svm_models/linear_svm_vlad.mat');
load(load_svm_model);

dim_spdvec  = dim*( dim + 1 )/2;
dim_vlad = K * dim_spdvec;

n_samples_test = length(list_pac_te);
X_test = zeros(dim_vlad,n_samples_test);
labels_test = zeros(n_samples_test,1);
    

for i=1: n_samples_test    
   
    
    person   = list_pac_te{i,1};
    action   = list_pac_te{i,2};
    act      = list_pac_te{i,4};
    
    load_vlad=  strcat('./vlad/vlad_',person, '_', action, '.h5' );
    data_one_vlad= hdf5info( char(load_vlad) );
    vlad_i = hdf5read(data_one_vlad.GroupHierarchy.Datasets(1));
    vlad_i = vec(vlad_i);
    % power "normalisation"
    vlad_i = sign(vlad_i) .* sqrt(abs(vlad_i));
    %L2 normalization 
    vlad_i = vlad_i / sqrt(vlad_i'*vlad_i);
    
    
    X_test(:,i) = vlad_i; 
    labels_test(i) = act;
    
end


 data_test = X_test';
 [predicted_label, accuracy, prob_estimates] = svmpredict(labels_test, X_test', model, ['-b 1']);
