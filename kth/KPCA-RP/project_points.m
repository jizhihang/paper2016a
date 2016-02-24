function project_points (list_pac, path, load_sub_path)

matlabpool(8) 
folder_name = 'projected_points';
load('random_projection_data') % Loading V & X_train. See random_projection

%Stein Divergence Kernel
beta  = 1;
SD_Kernel = @(X,Y,beta) exp( -beta*( log(det( 0.5*(X + Y) )) - 0.5*log(det(X*Y )) ) );





for i=1: length(list_pac)
    
    person =  list_pac{i,1};
    action =  list_pac{i,2};
    num_covs = list_pac{i,3};     
    %show_you = strcat(person,  '_', action);
    %disp(show_you);
    
    parfor c  = 1:num_covs 
    %for c = 1:num_covs 
    load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(c) , '.h5' );
    S = char(load_cov);
    data_one_cov= hdf5info(S);
    Xi = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point
    size(X_train)
    K_hat = compute_kernel(Xi,X_train, SD_Kernel, beta);
    x_i = K_hat*V;
   
    %pp = projected point
    save_pp =  strcat('./', folder_name, '/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
    hdf5write(save_pp, '/dataset1', x_i);
    
    end
end

matlabpool close


