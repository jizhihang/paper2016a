function [cluster_list n_points_cl] = assign_points(one_video_pac, K,path, load_sub_path, folder_name_cl)


person =  one_video_pac{1,1};
action =  one_video_pac{1,2};
num_covs = one_video_pac{1,3};
cluster_list =  cell(num_covs,K);
n_points_cl  =  zeros(1,K);
%matlabpool(8)




for c = 1:num_covs
    
    load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(c) , '.h5' );
    S = char(load_cov);
    data_one_cov= hdf5info(S);
    cov = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
    dist = zeros(1,K);
    
    
    %parfor k=1:K
    for  k=1:K
        load_cluster =  strcat(path, 'K_means_SPD/', folder_name_cl, '/cluster_', num2str(k), '_out_', num2str(K), '.h5' );
        Sc = char(load_cluster);
        data_one_cluster= hdf5info(Sc);
        cluster = hdf5read(data_one_cluster.GroupHierarchy.Datasets(1));
        dist(k) = cluster_distance (cluster, cov);
    end
    
    
    
    
    [mini posi ] = min( dist ); % Storing the closest cluster idx in posi
    n_points_cl(posi) =  n_points_cl(posi) + 1;
    new_list_pac_cov = {one_video_pac{1,:}};
    new_list_pac_cov{3}  = c;
    cluster_list{ n_points_cl(posi), posi} = new_list_pac_cov;
    
    
end

%matlabpool close