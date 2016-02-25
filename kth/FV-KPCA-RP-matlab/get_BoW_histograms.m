function get_BoW_histograms(one_video_pac, K,path, dim)


person =  one_video_pac{1,1};
action =  one_video_pac{1,2};
num_covs = one_video_pac{1,3};
%matlabpool(8)

hist_i = zeros(K,1);

load_Kmeans =  strcat( './Kmeans/means_K', num2str(K), '_dim',num2str(dim) );
save(char(load_Kmeans ));  % C i size(dim,K), each column is a Centroid

for c = 1:num_covs
    
    
    %Loading Projected Point
    load_pp_vector =  strcat( path, 'KPCA-RP/projected_points_dim', num2str(dim),'/pp_', person, '_', action,  '_segm', num2str(c) , '.h5' );
    S = char(load_pp_vector);
    data_one_cov= hdf5info(S);
    xi = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point
    dist = zeros(1,K);
    
    
    for  k=1:K
        C_k = C(:,k);
        dist(k) =  norm(xi - C_k);
    end
    
    
    
    
    [mini posi ] = min( dist ); % Storing the closest cluster idx in posi
    
    hist_i (posi) = hist_i (posi) + 1;
    
    
    
end
%Saving the histograms for the projected points.
save_hist=  strcat('./BoW_hist_K', num2str(K), '/pp_hist_', person, '_', action, '.h5' );
hdf5write(char(save_hist), '/dataset1', hist_i);
% Guardar Aqui!!!!!
%matlabpool close