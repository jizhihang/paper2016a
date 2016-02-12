clear all
clc
dbstop error;
%dbstop in assign_points at 38;

prompt = 'Folder name to save clusters ';
%folder_name = input(prompt, 's');
folder_name = strcat(input(prompt, 's'),date);
%parent_dir = pwd;
mkdir(pwd, folder_name);

%%Change this
K = 10;
n_iter =10;

%%
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
dim = 14;
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;


load_sub_path =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, cells
[list_pac total_num_covs] = get_list(n_people, n_actions, path, all_people, actions, load_sub_path);

cluster_idx_pac = initial_centers (list_pac, K); %
save_initial_clusters_parfor(path, load_sub_path, K, cluster_idx_pac,folder_name );





for i=1:n_iter
    
    i
    tic
    [cluster_list n_points_cl] = parfor_assign_points(list_pac, K,path, load_sub_path, total_num_covs);
    toc
    
    tic
    get_centers_parfor (cluster_list, n_points_cl, path, load_sub_path, K, dim)
    toc
    
end