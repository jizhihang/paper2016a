function FV_layers_2 ( path_dataset, view, all_years, K,  GMM_folder, FV_folder_ly1, red_FV_folder, FV_folder_ly2, run )

load_gmm_model =  strcat( './',GMM_folder, '/gmm_model_K', num2str(K), '_view', num2str(view), '_run', num2str(run) );
load(char(load_gmm_model), 'means','covariances','priors');

n_years = length(all_years);



for y=1:n_years
    
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    load_n_segments = strcat('./', FV_folder_ly1, '/MissUniverse', year, '/n_segments_view', num2str(view), '_run', num2str(run) , '.mat');
    load(load_n_segments, 'n_segments');
    
    
    FV_MU = strcat(FV_folder_ly2, '/MissUniverse', year);
    
    if ~exist(FV_MU, 'dir')
        
        mkdir(FV_MU);
    end
    
    for c = 1:n_countries
        
        X = [ ];
        n_segm = cell2mat(n_segments(c,2));
        
        for i =1: n_segm
            
            load_red_FV=  strcat('./', red_FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '_segm', num2str(i), '.h5' );
            red_FV =  hdf5info( char(load_red_FV) );
            vi = hdf5read(red_FV.GroupHierarchy.Datasets(1));
            X = [X vi];
            
        end
        
        vectors_country_i = {X};
        v = compute_fisher_joha (single(priors), single(means), single(covariances), vectors_country_i);
        %d_fisher = size (v, 1);              % dimension of the Fisher vectors
        
        % power "normalisation"
        v = sign(v) .* sqrt(abs(v));
        
        %L2 normalization (may introduce NaN vectors)
        vn = yael_fvecs_normalize (v);
        
        
        if ( length( find( isnan(vn) ) )> 0 )
            disp('Que hago??????');
        end
        
        
        save_FV=  strcat('./', FV_folder_ly2, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),'.h5' );
        char(save_FV);
        hdf5write(char(save_FV), '/dataset1', vn);
        
    end
    
    
    
    
end