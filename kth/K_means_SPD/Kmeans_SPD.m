clear all
clc
dbstop error;


%Change this
K = 10;

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
list_pac = get_list(n_people, n_actions, path, all_people, actions, load_sub_path);

cluster_idx_pac = initial_centers (list_pac, K); % 

save_initial_clusters(path, load_sub_path, K, cluster_idx_pac);


%cluster_list =  cell(5,2)