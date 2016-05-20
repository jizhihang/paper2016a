function main_FV_layer1_NP_14(path_dataset, path_features, all_years, K, segm_length, n_iterGMM, FV_folder, red_FV_folder2, GMM_folder   )

view = 1;

%Leave-One-Out Cross-Validation. Leaving One Year Out
for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
    all_years = [ years_train years_test ];
    
    get_universalGMM(path_dataset,  path_features, view, years_train,  K,  n_iterGMM, GMM_folder, run);
    FV_layers_1  ( path_dataset, path_features, view, all_years, K,  GMM_folder, FV_folder, run, segm_length );
    
    dim_reduction2( path_dataset, view, years_train, FV_folder, run);
    
    project_points_PCA( path_dataset, view, all_years, FV_folder, red_FV_folder2, run)

    
    
end


