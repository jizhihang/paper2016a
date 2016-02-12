function [cluster_list n_points_cl] = assign_points(list_pac, K,path, load_sub_path,total_num_covs)

cluster_list =  cell(total_num_covs,K);
n_points_cl  =  zeros(1,K);


for i=1: length(list_pac)
    
   
    
    person =  list_pac{i,1};
    action =  list_pac{i,2};
    num_covs = list_pac{i,3};
     
    %show_you = strcat(person,  '_', action);
    %disp(show_you);
    
    for c = 1:num_covs
        
        load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(c) , '.h5' );
        S = char(load_cov);
        data_one_cov= hdf5info(S);
        cov = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
        dist = zeros(1,K);
        
        for k=1:K
            load_cluster =  strcat('./clusters_spd/cluster_', num2str(k), '_out_', num2str(K), '.h5' );
            Sc = char(load_cluster);
            data_one_cluster= hdf5info(Sc);
            cluster = hdf5read(data_one_cluster.GroupHierarchy.Datasets(1));
            dist(k) = cluster_distance (cluster, cov);
        end
        
        
        
        [mini posi ] = min( dist ); % Storing the closest cluster idx in posi
        n_points_cl(posi) =  n_points_cl(posi) + 1;
        new_list_pac_cov = {list_pac{i,:}};
        new_list_pac_cov{3}  = c;
        cluster_list{ n_points_cl(posi), posi} = new_list_pac_cov;
        
        
    end
    
    %cluster_list{ n_points_cl(posi), posi}{3}

    
end