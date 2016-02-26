clear all
clc

%Wanda
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
addpath('/home/johanna/toolbox/libsvm-3.20/matlab')

%Mounted Wanda @ UQ
%path = '/home/johanna-uq/WANDA_DRIVE/';
%addpath('/home/johanna-uq/Toolbox/libsvm-320/matlab')

dbstop error;
%dbstop in get_BoW_histograms at 43

K = 256;
folder_name_cl = 'clustersSPD_15-Feb-2016_K_256';

%K = 128;
%folder_name_cl = 'clustersSPD_18-Feb-2016_K_128';

show_you = strcat('Folder: ', folder_name_cl);
disp(show_you);

dim = 14;
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;

%%

load_sub_path =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));
n_actions = length(actions);

people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];
people_test =   [ 2 3 5 6 7  8  9  10 22 ];

%pac : people, action, cells

[list_pac_te total_num_covs_te] = get_list( n_actions, path, all_people, actions, load_sub_path, people_test);
[list_pac_tr total_num_covs_tr] = get_list( n_actions, path, all_people, actions, load_sub_path, people_train);

%% Getting descriptors for Training Set


%pac : people, action, cells

  
%    for i=1:length(list_pac_tr)
%        i
%        one_video_pac = {list_pac_tr{i,:}};
%        tic
%        [cluster_list_one_video n_points_cl] = get_BoW_histograms(one_video_pac, K,path, load_sub_path, folder_name_cl);
%        toc
%    end



%% Getting descriptors for Testing Set

 
%   for i=1:length(list_pac_te)
%       i
%       one_video_pac = {list_pac_te{i,:}};
%       tic
%       [cluster_list_one_video n_points_cl] = get_BoW_histograms(one_video_pac, K,path, load_sub_path, folder_name_cl);
%       toc
%   end
 



%% Train and Test with SVM
BoW_svm_train(K, list_pac_tr);
[predicted_label, accuracy, dec_values] = BoW_svm_test(K, list_pac_te);
