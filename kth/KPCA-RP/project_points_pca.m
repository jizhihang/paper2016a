function project_points_pca (list_pac,  folder_name, new_folder_name, new_dim)

%X = zeros( total_num_covs_tr, dim_ps );

load_rp_data = strcat('pca_projection_data_dim',  num2str(new_dim));
load(char(load_rp_data),'W', 'U','S','V', 'NP');


    
    for i=1: length(list_pac)
        
        person =  list_pac{i,1};
        action =  list_pac{i,2};
        num_covs = list_pac{i,3};
        show_you = strcat(person,  '_', action);
        disp(show_you);
        
        %parfor c  = 1:num_covs
        for c = 1:num_covs
           
            
            load_pp_vector =  strcat('./', folder_name, '/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
            S = char(load_pp_vector);
            data_one_cov= hdf5info(S);
            one_ppoint = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point
            
            xi=one_ppoint'*W;
            
            save_pp_pca =  strcat('./', new_folder_name, '/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
            hdf5write(char(save_pp_pca), '/dataset1', xi);
            
            
            %hdf5write(char(save_pp), '/dataset1', pca_one_point);
            
        end
    end
    
    
