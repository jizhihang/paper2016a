function get_universalGMM_ly2(path_dataset, view, years_train,  K,  n_iterGMM, GMM_folder, run, FV_folder_ly1, red_FV_folder)

n_years = length(years_train);


X = [ ] ;

for y=1:n_years
    
    year = num2str( years_train(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
   
    load_n_segments = strcat('./', FV_folder_ly1, '/MissUniverse', year, '/n_segments_view', num2str(view), '_run', num2str(run) , '.mat');
    load(load_n_segments, 'n_segments');
    
    for c = 1:n_countries

        n_segm = cell2mat(n_segments(c,2));
        
        
        for i =1: n_segm
            
            
            load_red_FV=  strcat('./', red_FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '_segm', num2str(i), '.h5' );
            red_FV =  hdf5info( char(load_red_FV) );
            vi = hdf5read(red_FV.GroupHierarchy.Datasets(1)); 
            
            X = [X vi];
           
        
        end
        
    end
    
end


%size(X)

disp('GMM 2nd layer')
tic
[means, covariances, priors] = vl_gmm(X, K,  'MaxNumIterations', n_iterGMM);
toc

save_gmm_model =  strcat( './',GMM_folder, '/gmm_model_K', num2str(K), '_view', num2str(view), '_run', num2str(run) );
save(char(save_gmm_model), 'means','covariances','priors');