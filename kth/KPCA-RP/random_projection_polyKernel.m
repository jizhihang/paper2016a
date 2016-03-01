function  random_projection_polyKernel(list_pac, r_points, path, load_sub_path, dim)
%r_points == length(list_pac)


%Polynomial Kernel - See mlsda paper on Manifolds
best_n = 12;
gamma = 1/best_n;

LED_POLY_KERNEL = @(X,Y,gamma,best_n)( ( gamma*( trace(logm(X)'*logm(Y)) ) )^best_n );
X_train = zeros( dim, dim, r_points);
    

matlabpool(8) 


for i=1: r_points    
   
    
    person =  list_pac{i,1};
    action =  list_pac{i,2};
    c = list_pac{i,3};
    
    
    load_cov =  strcat( path, load_sub_path, '/Cov_', person, '_', action,  '_segm', num2str(c) , '.h5' );
    S = char(load_cov);
    data_one_cov= hdf5info(S);
    cov = hdf5read(data_one_cov.GroupHierarchy.Datasets(1));
    X_train(:,:,i) = cov;
end
matlabpool close


Ks = compute_proj_kernel(X_train,X_train, LED_POLY_KERNEL, gamma, best_n);
[U,S,V] = svd(Ks); % use matrix V 

%To project each point, it means to project each covariance matrix.
save_rp_data = strcat('PolyKernelrandom_projection_data_dim',  num2str(r_points));
save(char(save_rp_data),'V', 'Ks', 'X_train');


