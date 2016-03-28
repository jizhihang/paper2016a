function main_FV_layer2(path_dataset, all_years, K,  n_iterGMM, FV_folder_ly1, red_FV_folder, FV_folder_ly2, GMM_folder  )


view = 1;




%Leave-One-Out Cross-Validation. Leaving One Year Out
for i = 1: length( all_years)
    
    run = i;
    years_train  =  all_years;
    years_train(i) = [];
    years_test  = all_years(i) ;
    
    all_years = [ years_train years_test ];
    
    get_universalGMM_ly2(path_dataset, view, years_train,  K,  n_iterGMM, GMM_folder, run, FV_folder_ly1, red_FV_folder);
    FV_layers_2 ( path_dataset, view, all_years, K,  GMM_folder, FV_folder_ly1, red_FV_folder, FV_folder_ly2, run )

end


