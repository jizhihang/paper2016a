clear all
clc
dbstop error;
%dbstop in vec_TestingSet at 10
%dbstop in vec_Clusters at 5

K = 256;
folder_name_cl = 'clusters_pruebas_vlda_borrar';


show_you = strcat('Folder: ', folder_name_cl);
disp(show_you);
    
dim = 14;
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;    
    
%%
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
load_sub_path =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));

people_test =   [ 2 3 5 6 7  8  9  10 22 ];
n_actions = length(actions);

%pac : people, action, cells
[list_pac_te total_num_covs_te] = get_list( n_actions, path, all_people, actions, load_sub_path, people_test);

%vec_TestingSet (path, load_sub_path, list_pac_te, dim );
%vec_Clusters(path, folder_name_cl, K, dim);



for i=1:length(list_pac_te)
    i
    one_video_pac = {list_pac_te{i,:}};  
    [cluster_list_one_video n_points_cl] = assign_points(one_video_pac, K,path, load_sub_path, folder_name_cl);
    get_vlad_descriptors (list_pac_te, cluster_list, n_points_cl, dim, K);

end


