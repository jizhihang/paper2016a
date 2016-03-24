function dim_reduction (path_dataset, view, train_years, years_test,  FV_folder, run)
%Dimensionality Reduction using Max-Margin

n_years = length(train_years);
total_segments = 0;


for y=1:n_years
    
    year = num2str( train_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    FV_MU = strcat(FV_folder, '/MissUniverse', year);
    
    
    load_n_segments = strcat('./', FV_folder, '/MissUniverse', year, '/n_segments_view', num2str(view), '_run', num2str(run) , '.mat');
    load(load_n_segments, 'n_segments');
    
  
    
    for c = 1:n_countries
        
        
       
        n_segm = n_segments(c,2);
        
        total_segments = total_segments + n_segm;
        
        %for i = n_segm
            %load_FV=  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '_segm', num2str(seg_i), '.h5' );
            %name_FV_v_segm_i = hdf5info( char(load_FV) );
            %FV_v_segm_i = hdf5read(name_FV_v_segm_i.GroupHierarchy.Datasets(1));
        
        %end
        
    end
    
end


