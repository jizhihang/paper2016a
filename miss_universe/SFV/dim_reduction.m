function dim_reduction (path_dataset, view, train_years,  FV_folder, run)
%Dimensionality Reduction using Max-Margin

n_years_tr = length(train_years);
total_segments = 0;

X = [];

for y=1:n_years_tr
    
    year = num2str( train_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    FV_MU = strcat(FV_folder, '/MissUniverse', year);
    
    
    load_n_segments = strcat('./', FV_folder, '/MissUniverse', year, '/n_segments_view', num2str(view), '_run', num2str(run) , '.mat');
    load(load_n_segments, 'n_segments');
    
  
    
    for c = 1:n_countries
        
        
       
        n_segm = cell2mat(n_segments(c,2));
        
        total_segments = total_segments + n_segm;
        
        for i =1: n_segm
            load_FV=  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '_segm', num2str(i), '.h5' );
            name_FV_v_segm_i = hdf5info( char(load_FV) );
            FV_v_segm_i = hdf5read(name_FV_v_segm_i.GroupHierarchy.Datasets(1));
            X = [X FV_v_segm_i ];
        
        end
        
    end
    
end

[W U S V NP] = get_PCA_transformation_matrix (X');


 save_rp_data = strcat('./', FV_folder, '/pca_projection_data_run', num2str(run));
 %save(char(save_rp_data),'W', 'U','S','V', 'NP');
 save(char(save_rp_data),'W', 'NP');

