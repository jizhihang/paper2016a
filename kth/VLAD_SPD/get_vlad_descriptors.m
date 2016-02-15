function get_vlad_descriptors (cluster_list, n_points_cl, dim)

%matlabpool(8) 

dim_spdvec  = dim*( dim + 1 )/2;


vlad = zeros(K,dim_spdvec);

for k = 1:K
    
    load_vec_cluster =  strcat('./vec_Clusters/vec_cluster_', num2str(k), '_out_', num2str(K), '.h5' );
    Sc = char(load_vec_cluster);
    data_one_cluster= hdf5info(Sc);
    cluster_k = hdf5read(data_one_cluster.GroupHierarchy.Datasets(1));
    
    num_points_k = n_points_cl(k);
    
    if (num_points_k ==0)
        disp('You have a serious problem')
        pause
    end
   
 
    vi = zeros(dim_spdvec);
    for p=1:num_points_k
        
        person =  cluster_list{ p, k}{1};
        action =  cluster_list{ p, k}{2};
        idx_cov = cluster_list{ p, k}{3};
        
        load_vec_cov =  strcat('./vec_TestingSet/vecSPD_', person, '_', action,  '_segm', num2str(idx_cov) , '.h5' );
        S = char(load_vec_cov);
        data_one_cov= hdf5info(S);
        vec_cov_p = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
        sub = (vec_cov_p - cluster_k);
        vi = vi + sub;

    end
    
    vlad(k,:) = vi;
    
    save_vlad=  strcat('./vlad/vlad_',person, '_', action,  '_segm', num2str(c) , '.h5' );
    hdf5write(save_vlad, '/dataset1', vlad);
    
end
%matlabpool close
