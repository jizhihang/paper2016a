function save_initial_clusters_parfor(path, load_sub_path, K, cluster_idx_pac)



for k=1: K
    
    person =  cluster_idx_pac{k,1};
    action =  cluster_idx_pac{k,2};
    idx_cov = cluster_idx_pac{k,3};
    
    
    load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(idx_cov) , '.h5' );
    S = char(load_cov);
    data_one_cov= hdf5info(S);
    cov = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
    
    
    save_cov =  strcat('./par_for_clusters_spd/cluster_', num2str(k), '_out_', num2str(K), '.h5' );
    hdf5write(save_cov, '/dataset1', cov);
      
      
end

 
      