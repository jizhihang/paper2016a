clear all
clc
dbstop error;


%Check this path
path  = '~/codes/codes-git/paper2016a/trunk/kth/';
dim = 14;
actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');
scale_factor = 1;
shift = 0;


n_people  = length(all_people);
n_actions = length(actions);

%pac : people, action, cells
list_pac = get_list(n_people, n_actions, path, all_people, actions , scale_factor, shift);




cluster_list =  cell(5,2)