function get_universalGMM(path, list_pac, total_num_covs_tr, K, dim, num_iter, n_iterGMM)


X = zeros(dim, total_num_covs_tr);

k =1;
for i=1: length(list_pac)
    
    person =  list_pac{i,1};
    action =  list_pac{i,2};
    num_covs = list_pac{i,3};     
    %show_you = strcat(person,  '_', action);
    %disp(show_you);
    
    %parfor c  = 1:num_covs 
    for c = 1:num_covs 
        %Loading Projected Point
        load_pp_vector =  strcat( path, 'KPCA-RP/projected_points_dim', num2str(dim),'/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
        S = char(load_pp_vector);
        data_one_cov= hdf5info(S);
        xi = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point
        X(:,k) = xi;
        k = k+1;
    end
end

disp('Kmeans');
tic
C = vl_kmeans(X,K,'NumRepetitions',num_iter);
toc

disp('GMM');
tic
vl_gmm(X, K,  'MaxNumIterations', n_iterGMM, 'InitMeans', C);
toc
