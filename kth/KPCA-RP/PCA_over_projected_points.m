function PCA_over_projected_points (list_pac_tr,  folder_name,  total_num_covs_tr, dim_ps)


X = zeros( total_num_covs_tr, dim_ps );

k =1;
    
    for i=1: length(list_pac_tr)
        
        person =  list_pac_tr{i,1};
        action =  list_pac_tr{i,2};
        num_covs = list_pac_tr{i,3};
        show_you = strcat(person,  '_', action);
        disp(show_you);
        
        %parfor c  = 1:num_covs
        for c = 1:num_covs
           
            
            load_pp_vector =  strcat('./', folder_name, '/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
            S = char(load_pp_vector);
            data_one_cov= hdf5info(S);
            one_ppoint = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point
            X(k,:) = one_ppoint';
            k = k+1;
            %pca_one_point = 0;
            %save_pp =  strcat('./', folder_name, '/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
            %hdf5write(char(save_pp), '/dataset1', pca_one_point);
            
        end
    end
    
    
Sigma=cov(X);
[U,S,V] = svd(Sigma);

eigVals = diag(S);
%eigVecs = U;

for i = 1: length(eigVals)
energy(i) = sum(eigVals(1:i));
end

propEnergy = energy./energy(end);
percentMark = min(find(propEnergy > 0.9));
NP = percentMark;

W = U(:,1:NP);

save_rp_data = strcat('pca_projection_data_dim',  num2str(NP));
save(char(save_rp_data),'W', 'U','S','V', 'NP');
    


