%% Si es mas rapido

clear all
clc
dbstop error;
%dbstop in random_projection at 38;

   
   
%%
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
dim = 4237; % After the random projection
K = 256;
num_iter = 10; %  forKmeans
n_iterGMM = 5; % For GMM
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


get_universalGMM(path, list_pac, total_num_covs_tr, K, dim, num_iter, n_iterGMM);

