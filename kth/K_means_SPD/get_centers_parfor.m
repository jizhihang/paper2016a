function get_centers_parfor (cluster_list, n_points_cl, path, load_sub_path, K, dim,folder_name)

matlabpool(8) 

for k = 1:K
    
    load_cluster =  strcat('./par_for_clusters_spd/cluster_', num2str(k), '_out_', num2str(K), '.h5' );
    Sc = char(load_cluster);
    data_one_cluster= hdf5info(Sc);
    old_cluster_k = hdf5read(data_one_cluster.GroupHierarchy.Datasets(1));
    
    
    num_points_k = n_points_cl(k);
    
    if (num_points_k ==0)
        disp('You have a serious problem')
        pause
    end
   
   new_cluster_k = zeros(dim,dim,num_points_k);
    
    parfor p=1:num_points_k
        
        person =  cluster_list{ p, k}{1};
        action =  cluster_list{ p, k}{2};
        idx_cov = cluster_list{ p, k}{3};
        
        load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(idx_cov) , '.h5' );
        S = char(load_cov);
        data_one_cov= hdf5info(S);
        cov_p = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
        
        new_cluster_k(p,:,:) = inv(0.5*(cov_p + old_cluster_k ));

    end
    
    new_cluster_k=sum(new_cluster_k,3);
    
    new_cluster_k = inv(new_cluster_k/num_points_k);
    
    save_cluster =  strcat('./', folder_name, '/cluster_', num2str(k), '_out_', num2str(K), '.h5' );
    hdf5write(save_cluster, '/dataset1', new_cluster_k);
    
end
matlabpool close
