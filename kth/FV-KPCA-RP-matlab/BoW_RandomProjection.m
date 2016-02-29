%VL
run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');

%LIBSVM
addpath('/home/johanna/toolbox/libsvm-3.20/matlab')

clear all
clc
dbstop error;
%dbstop in random_projection at 38;



%%
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
dim = 4237
%dim = 8475 % After the random projection
%K = 256;
num_iter = 10; %  forKmeans
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;

people_test =  [ 2 3 5  6  7  8  9  10 22 ];
people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];

load_sub_path_1 =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, #covs
[list_pac_tr total_num_covs_tr] = get_list( n_actions, path, all_people, actions, load_sub_path_1, people_train);
[list_pac_te total_num_covs_te] = get_list( n_actions, path, all_people, actions, load_sub_path_1, people_test);

%vec_K = [128 256 512 4000];
vec_K = [512 ];

for k =1:length(vec_K)
    K = vec_K(k)
    
    %% Get Kmeans (Vocabulary)
    disp('Kmeans');
    get_Kmeans(path, list_pac_tr, total_num_covs_tr, K, dim, num_iter)
    
    %% Getting descriptors for Training Set
    
    
    for i=1:length(list_pac_tr)
        %i
        one_video_pac = {list_pac_tr{i,:}};
        %tic
        get_BoW_histograms(one_video_pac, K,path, dim);
        %toc
    end
    
    %% Getting descriptors for Testing Set
    
    for i=1:length(list_pac_te)
        %i
        one_video_pac = {list_pac_te{i,:}};
        %tic
        get_BoW_histograms(one_video_pac, K,path, dim);
        %toc
    end
    
end

%% Train and Test with SVM
%BoW_svm_train(K, list_pac_tr);
%[predicted_label, accuracy, dec_values] = BoW_svm_test(K, list_pac_te);
