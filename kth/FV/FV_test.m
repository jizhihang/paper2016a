function [predicted_label, accuracy, dec_values]  = FV_test(people_test, all_people, actions,  K, dim, dim_FV, FV_folder, svm_folder)

n_actions = size(actions,1);
n_samples_train = length(people_test)*n_actions;

X_test = zeros(dim_FV, n_samples_train);
labels_train = zeros(n_samples_train,1);
j = 1;

load_svm_model = strcat( './',svm_folder, '/linear_kernel_svm_FV_K', num2str(K), '_dim', num2str(dim), '.mat');
load(load_svm_model, 'model');

for p=1: length(people_test)
   
    person = all_people(people_test(p));
    person
    for act = 1:n_actions
        
        load_FV =  strcat('./', FV_folder, '/FV_', person, '_', actions(act), '_dim', num2str(dim),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        FVi = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); % One covariance point
        X_test(:,j) = FVi;
        labels_train(j) = act;
        j = j + 1;
        
    end
   
end

[predicted_label, accuracy, dec_values] = svmpredict(labels_test, X_test', model);