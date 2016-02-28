function FV_kth_all_videos(one_video_pac, K,path, dim)
%%Calcular FV for all videos



person =  one_video_pac{1,1};
action =  one_video_pac{1,2};
num_covs = one_video_pac{1,3};
%matlabpool(8)

X = zeros (dim,num_covs);


load_gmm =  strcat( './universal_GMM/gmm_model_K', num2str(K), '_dim',num2str(dim) );
load(char(load_gmm)) % Loading means, covariances, priors

for c = 1:num_covs
    
    
    %Loading Projected Point
    load_pp_vector =  strcat( path, 'KPCA-RP/projected_points_dim', num2str(dim),'/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
    S = char(load_pp_vector);
    data_one_cov= hdf5info(S);
    X(:,c) = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point

end

v = compute_fisher_joha (single(priors), single(means), single(covariances), {X});
d_fisher = size (v, 1);              % dimension of the Fisher vectors

% power "normalisation"
v = sign(v) .* sqrt(abs(v));

%L2 normalization (may introduce NaN vectors)
vn = yael_fvecs_normalize (v);

%Saving the histograms for the projected points
save_FV=  strcat('./FV_K', num2str(K), '/FV_', person, '_', action, '_dim', num2srtr(dim),'.h5' );
hdf5write(char(save_FV), '/dataset1', vn);
