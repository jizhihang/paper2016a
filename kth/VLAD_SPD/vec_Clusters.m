function vec_Clusters (path, folder_name_cl, K, dim )

dim_spdvec  = dim*( dim + 1 )/2;


for i=1: K
    
     load_cluster =  strcat(path, './', folder_name_cl, '/cluster_', num2str(k), '_out_', num2str(K), '.h5' );
     S = char(load_cluster);
     data_one_cluster= hdf5info(S);
     cluster_k = hdf5read(data_one_cluster.GroupHierarchy.Datasets(1));
     
     vec_spd = vecSPD (cluster_k, dim, dim_spdvec);
     
     save_vec_cov =  strcat('./vec_Clusters/vec_cluster_', num2str(k), '_out_', num2str(K), '.h5' );
     hdf5write(save_vec_cov, '/dataset1', vec_spd);
        
end
