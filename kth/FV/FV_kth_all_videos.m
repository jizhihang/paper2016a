function FV_kth_all_videos(path_features, all_people, actions, K, dim, GMM_folder, FV_folder)
%%Calcular FV for all videos

scale = 1;
shift = 0;
path_1 = strcat( path_features, 'scale', num2str(scale), '-shift', num2str(shift), '/');
        



load_gmm_model =  strcat( './',GMM_folder, '/gmm_model_K', num2str(K), '_dim',num2str(dim) );
load(char(load_gmm_model), 'means','covariances','priors');

n_people  = length(all_people);
n_actions = length(actions);

for pe=1:n_people
    
    for act=1:n_actions
        
        load_video_i=  strcat( path_1,all_people(pe), '_', actions(act), '_dim', num2str(dim), '.h5');
        S = char(load_video_i);
        data_onevideo = hdf5info(S);
        one_video = hdf5read(data_onevideo.GroupHierarchy.Datasets(1));
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
        save_FV=  strcat('./', FV_folder, '/FV_', all_people(pe), '_', actions(act), '_dim', num2str(dim),'.h5' );
        hdf5write(char(save_FV), '/dataset1', vn);
    end
    
end


