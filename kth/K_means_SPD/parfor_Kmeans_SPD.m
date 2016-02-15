%% Si es mas rapido

clear all
clc
dbstop error;
%dbstop in assign_points at 38;

%% INPUTS
prompt = 'Number of Iterations ';
n_iter = input(prompt);

prompt = 'Number of Clusters ';
K = input(prompt);


prompt = 'Folder name to save clusters ';
folder_name = strcat(input(prompt, 's'),date,'_K_',num2str(K));
%parent_dir = pwd;
mkdir(pwd, folder_name);

%K = 10;
%n_iter =10;


show_you = strcat('Folder', folder_name);
disp(show_you);
    
    
    
%%
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
dim = 14;
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;

people_test =   [ 2 3 5  6  7  8  9  10 22 ];
people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];

load_sub_path =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, cells
[list_pac_tr total_num_covs_tr] = get_list( n_actions, path, all_people, actions, load_sub_path, people_train);

cluster_idx_pac = initial_centers (list_pac_tr, K); %
save_initial_clusters_parfor(path, load_sub_path, K, cluster_idx_pac,folder_name );


all_distances_iter = zeros(n_iter,K);


for i=1:n_iter
    
    i
    tic
    [cluster_list n_points_cl all_distances] = parfor_assign_points(list_pac_tr, K,path, load_sub_path, total_num_covs_tr,folder_name);
    all_distances_iter(i,:) = all_distances;
    toc
    
    if length(find(n_points_cl==0)) > 0
        
    end
    
    tic
    get_centers_parfor (cluster_list, n_points_cl, path, load_sub_path, K, dim,folder_name)
    toc
    
end