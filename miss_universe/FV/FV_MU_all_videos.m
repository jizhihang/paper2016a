function FV_MU_all_videos(path_dataset, path_features, view, all_years, K,  GMM_folder, FV_folder, run)
%%Calcular FV for all videos



n_years = length(all_years);

load_gmm_model =  strcat( './',GMM_folder, '/gmm_model_K', num2str(K), '_view', num2str(view), '_run', num2str(run) );
load(char(load_gmm_model), 'means','covariances','priors');




for y=1:n_years
   
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    FV_MU = strcat(FV_folder, '/MissUniverse', year);
    
    if ~exist(FV_MU, 'dir')
    
        mkdir(FV_MU);
    end
    
    
    for c = 1:n_countries
        load_video_i=  strcat( path_features, 'MissUniverse', year, '/', countries(c), '_view', num2str(view), '.h5');
        S = char(load_video_i);
        vectors_one_video= hdf5info(S);
        one_video = hdf5read(vectors_one_video.GroupHierarchy.Datasets(1)); % One covariance point
        
        one_video= {one_video};
        
        v = compute_fisher_joha (single(priors), single(means), single(covariances), one_video);
        
        d_fisher = size (v, 1);              % dimension of the Fisher vectors
        
        % power "normalisation"
        v = sign(v) .* sqrt(abs(v));
        
        %L2 normalization (may introduce NaN vectors)
        vn = yael_fvecs_normalize (v);
        
        % replace NaN vectors with a large value that is far from everything else
        % For normalized vectors in high dimension, vector (0, ..., 0) is *close* to
        % many vectors.
        %vn(find(isnan(vn))) = 123;
        
        if ( length( find( isnan(vn) ) )> 0 )
            disp('Que hago??????');
            
        end
        
        %to save        
        save_FV=  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run), '.h5' );
        hdf5write(char(save_FV), '/dataset1', vn);
    end

end
