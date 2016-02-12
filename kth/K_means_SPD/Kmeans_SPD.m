clear all
clc
dbstop error;
%dbstop in assign_points at 38;


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
save_initial_clusters(path, load_sub_path, K, cluster_idx_pac);





for i=1:n_iter
    
    i
    tic
    [cluster_list n_points_cl] = assign_points(list_pac, K,path, load_sub_path, total_num_covs);
    toc
    
    tic
    get_centers (cluster_list, n_points_cl, path, load_sub_path, K, dim)
    toc
    
end

% i =     1
% 
% Elapsed time is 1792.050082 seconds.
% Elapsed time is 185.476685 seconds.
% 
% i =     2
% 
% Elapsed time is 1798.734165 seconds.
% Elapsed time is 183.089404 seconds.
% 
% i =     3
% 
% Elapsed time is 3690.375156 seconds.
% Elapsed time is 894.102499 seconds.
% 
% i =     4
% 
% Elapsed time is 10720.193069 seconds.
% Elapsed time is 1117.689026 seconds.
% 
% i =     5
% 
% Elapsed time is 13623.868074 seconds.
% Elapsed time is 1350.799642 seconds.
% 
% i =    6
% 
% Elapsed time is 17498.234280 seconds.
% Elapsed time is 1836.512534 seconds.
% 
% i =   7
