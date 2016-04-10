function project_points_RandomProjection (path_dataset, view, all_years, FV_folder, red_FV_folder_randomProjection, run)


n_years = length(all_years);
total_segments = 0;

load_rp_data = strcat('./', FV_folder, '/random_projection_data_run', num2str(run));
load(char(load_rp_data),'RandomMatrix');
W =  RandomMatrix;
    

for y=1:n_years
    
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    FV_MU = strcat(FV_folder, '/MissUniverse', year);
    
    
    load_n_segments = strcat('./', FV_folder, '/MissUniverse', year, '/n_segments_view', num2str(view), '_run', num2str(run) , '.mat');
    load(load_n_segments, 'n_segments');
    
    red_FV_MU = strcat(red_FV_folder, '/MissUniverse', year);
    
    if ~exist(red_FV_MU, 'dir')
        
        mkdir(red_FV_MU);
    end
    
  
    
    for c = 1:n_countries
        
        
       
        n_segm = cell2mat(n_segments(c,2));
        
        total_segments = total_segments + n_segm;
        
        for i =1: n_segm
            load_FV=  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '_segm', num2str(i), '.h5' );
            name_FV_v_segm_i = hdf5info( char(load_FV) );
            FV_v_segm_i = hdf5read(name_FV_v_segm_i.GroupHierarchy.Datasets(1));
            
            new_FV = FV_v_segm_i'*W;
            
            save_red_FV=  strcat('./', red_FV_folder_randomProjection, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '_segm', num2str(i), '.h5' );
            char(save_red_FV);
            hdf5write(char(save_red_FV), '/dataset1', new_FV);

           
        
        end
        
    end
    
end
