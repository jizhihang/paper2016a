function get_centers (cluster_list, n_points_cl, path, load_sub_path, K)



for k =1:K
    
num_points_k = n_points_cl(k);

if (num_points_k ==0)
    disp('You have a serious problem')
    pause
for p=1:num_points_k
    
    person =  cluster_list{ p, k}{1};
    action =  cluster_list{ p, k}{2};
    idx_cov = cluster_list{ p, k}{3};
    
    load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(idx_cov) , '.h5' );
    S = char(load_cov);
    data_one_cov= hdf5info(S);
    cov = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
    
    
end
    
end






% And Save!!!!!!!
