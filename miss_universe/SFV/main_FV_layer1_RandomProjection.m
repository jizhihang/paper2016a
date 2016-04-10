function main_FV_layer1_RandomProjection(path_dataset, path_features, all_years, K, segm_length, n_iterGMM, FV_folder, red_FV_folder, GMM_folder   )

view = 1;

%Leave-One-Out Cross-Validation. Leaving One Year Out
for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
    all_years = [ years_train years_test ];
    
    %get_universalGMM(path_dataset,  path_features, view, years_train,  K,  n_iterGMM, GMM_folder, run);
    %FV_layers_1  ( path_dataset, path_features, view, all_years, K,  GMM_folder, FV_folder, run, segm_length );
    
    %Use dimension reduction from PCA to create the Random Projection
    %Matrix
    load_rp_data = strcat('./', FV_folder, '/pca_projection_data_run', num2str(run));
    load(char(load_rp_data),'W', 'NP');
    size(W)
    NP
    pause
    
    
    %project_points_PCA( path_dataset, view, all_years, FV_folder, red_FV_folder, run)

    
    
end


