function FV_MU_all_videos_seg(path_dataset, path_features, view, all_years, K,  GMM_folder, FV_folder, run, n_segm)
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
        one_video = hdf5read(vectors_one_video.GroupHierarchy.Datasets(1));
        
        load_fr_video_i=  strcat( path_features, 'MissUniverse', year, '/lab_', countries(c), '_view', num2str(view), '.h5');
        S = char(load_fr_video_i);
        frames_one_video= hdf5info(S);
        list_fr_video = hdf5read(frames_one_video.GroupHierarchy.Datasets(1));
        
        uni= unique(list_fr_video);
        
        total_frames = max(uni) - min(uni);
        
        segm_length = floor(total_frames / n_segm);
        
        conc_FV = [];
        
        for i = 0:n_segm-1
            ini = segm_length*i + 1;
            fin = segm_length*(i+1);
            
            sub_video = [];
            
            
            for f = ini:fin
                q1 = find(list_fr_video==f);
                sub_video = [sub_video one_video(:,q1)];
            end
            
            
            sub_video = {sub_video};
            v = compute_fisher_joha (single(priors), single(means), single(covariances), sub_video);
            
            d_fisher = size (v, 1);              % dimension of the Fisher vectors
            
            % power "normalisation"
            v = sign(v) .* sqrt(abs(v));
            
            %L2 normalization (may introduce NaN vectors)
            vn = yael_fvecs_normalize (v);
            
            conc_FV = [conc_FV; vn];

            if ( length( find( isnan(vn) ) )> 0 )
                disp('Que hago??????');
                
            end
            
            
            
            
        end
        
        %to save. Incluir Segment
        
        % power "normalisation"
        conc_FV = sign(conc_FV) .* sqrt(abs(conc_FV));
        %L2 normalization
        conc_FV = yael_fvecs_normalize (conc_FV);
        save_FV=  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),  '.h5' );
        hdf5write(char(save_FV), '/dataset1', conc_FV);
    end
    
end


