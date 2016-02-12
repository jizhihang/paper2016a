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
list_pac = cell(n_people*n_actions,3);
k =1;
load_sub_path =strcat('./overlapped_covariances/Covs/sc1/scale', int2str(scale_factor), '-shift',  int2str(shift));


for pe = 1: n_people
    for act=1: n_actions
      list_pac{k,1}  = all_people(pe);      
      list_pac{k,2}  = actions(act);
      load_Numcov =  strcat( path, load_sub_path, '/NumCov_', all_people(pe), '_', actions(act),  '.dat');
      num_cov = load( char(load_Numcov) );
      list_pac{k,3}  = num_cov;
      list_pac{k,:}
      k=k+1;
      pause
        
    end
    
end



cluster_list =  cell(5,2)