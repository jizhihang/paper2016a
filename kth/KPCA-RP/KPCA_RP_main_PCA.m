% After using random projection points. Do PCA over new points 


clear all
clc
dbstop error;
dbstop in PCA_over_projected_points at 19
%dbstop in random_projection at 38;
%dbstop in project_points at 34

%% INPUTS
% prompt = 'Number of Iterations ';
% n_iter = input(prompt);

%prompt = 'Number of Random Points ';
%R = input(prompt);


    
 %Kernel Type:   
 kernel_type = 'poly'
 %kernel_type = 'stein'
   
%%
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
dim = 14;
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;

people_test =  [ 2 3 5  6  7  8  9  10 22 ];
people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];

load_sub_path =strcat('overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, #covs
[list_pac_tr total_num_covs_tr] = get_list( n_actions, path, all_people, actions, load_sub_path, people_train);
[list_pac_te total_num_covs_te] = get_list( n_actions, path, all_people, actions, load_sub_path, people_test);


r_points = floor(8475/10);
folder_name = strcat('projected_points_dim', num2str(r_points))
new_folder_name = strcat('pca_projected_points_dim', num2str(r_points))

% Get projected points for Training and Testing Set
disp('PCA for projected points for Training Set');
PCA_over_projected_points (list_pac_tr,  folder_name, new_folder_name);

disp('PCA for projected points for for Testing Set');
PCA_over_projected_points (list_pac_te, folder_name, new_folder_name);

