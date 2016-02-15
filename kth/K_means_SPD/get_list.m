function [list_pac total_num_covs] = get_list(n_actions, path, all_people, actions, load_sub_path, people_train)

n_people = length(people_train);



list_pac = cell(n_people*n_actions,3);
k =1;
total_num_covs = 0;



for pe = 1: n_people
    idx = people_train(pe);
    for act=1: n_actions
        
      list_pac{k,1}  = all_people(idx);      
      list_pac{k,2}  = actions(act);
      load_Numcov =  strcat( path, load_sub_path, '/NumCov_', all_people(pe), '_', actions(act),  '.dat');
      num_cov = load( char(load_Numcov) );
      total_num_covs = total_num_covs + num_cov;
      list_pac{k,3}  = num_cov;
      %list_pac{k,:}
      k=k+1;
      %pause
        
    end
    
end