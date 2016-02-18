function vec_TrainingSet (path, load_sub_path, list_pac_tr, dim )

dim_spdvec  = dim*( dim + 1 )/2;


for i=1: length(list_pac_tr)
    
   
    
    person   = list_pac_tr{i,1};
    action   = list_pac_tr{i,2};
    num_covs = list_pac_tr{i,3};
     
    %show_you = strcat(person,  '_', action);
    %disp(show_you);
    
    
    
    for c = 1:num_covs
        load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(c) , '.h5' );
        S = char(load_cov);
        data_one_cov= hdf5info(S);
        cov = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
        
         vec_spd = vecSPD (cov, dim, dim_spdvec);
         
         
        save_vec_cov =  strcat('./vec_TrainTestSet_K', num2str(K),'vecSPD_', person, '_', action,  '_segm', num2str(c) , '.h5' );
        hdf5write(char(save_vec_cov), '/dataset1', vec_spd);
        
    end
end
