clear all
clc
dbstop error;
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

%% Run the following only once. It's to create the random_space and it's RANDOM ;). 
%# of random points
r_points = floor(total_num_covs_tr*1/100)

random_idx_pac = random_points (list_pac_tr, r_points); 

%Using Stein Divergen Kernel as per Queena's paper
%if strcmp( kernel_type, 'stein') 
%folder_name = strcat('projected_points_dim', num2str(r_points))
%random_projection(random_idx_pac, r_points, path, load_sub_path, dim);
%end

%Using Polynomial Kernel. Best_n found in mlsda paper 2016.
if strcmp( kernel_type, 'poly') 
folder_name = strcat('PolyKernel_projected_points_dim', num2str(r_points))
%random_projection_polyKernel(random_idx_pac, r_points, path, load_sub_path, dim)
end

if strcmp( kernel_type, 'stein')
folder_name = strcat('projected_points_dim', num2str(r_points))
random_projection(random_idx_pac, r_points, path, load_sub_path, dim)
end

if ~exist(folder_name, 'dir')
    mkdir(folder_name);
end




% Get projected points for Training and Testing Set
%disp('project_points for Training Set');
%project_points (list_pac_tr,path, load_sub_path, r_points, folder_name, kernel_type);

disp('project_points for Testing Set');
project_points (list_pac_te, path, load_sub_path,r_points, folder_name, kernel_type);

