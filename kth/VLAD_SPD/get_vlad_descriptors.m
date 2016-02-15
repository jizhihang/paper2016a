function get_vlad_descriptors (one_video_pac, cluster_list_one_video, n_points_cl, dim, K)

%matlabpool(8) 

dim_spdvec  = dim*( dim + 1 )/2;


vlad = zeros(K,dim_spdvec);

person =  one_video_pac{1,1};
action =  one_video_pac{1,2};

for k = 1:K
    %k
    load_vec_cluster =  strcat('./vec_Clusters/vec_cluster_', num2str(k), '_out_', num2str(K), '.h5' );
    Sc = char(load_vec_cluster);
    data_one_cluster= hdf5info(Sc);
    cluster_k = hdf5read(data_one_cluster.GroupHierarchy.Datasets(1));
    
    num_points_k = n_points_cl(k);
    
    vi = zeros(1,dim_spdvec);
    
    for p=1:num_points_k
        
        %p
        idx_cov = cluster_list_one_video( p, k );
        
        load_vec_cov =  strcat('./vec_TestingSet/vecSPD_', person, '_', action,  '_segm', num2str(idx_cov) , '.h5' );
        S = char(load_vec_cov);
        data_one_cov= hdf5info(S);
        vec_cov_p = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
        sub = (vec_cov_p - cluster_k);
        vi = vi + sub';

    end
    
    vlad(k,:) = vi;
    
   
    
end

save_vlad=  strcat('./vlad/vlad_',person, '_', action, '.h5' );
hdf5write(save_vlad, '/dataset1', vlad);
%matlabpool close
