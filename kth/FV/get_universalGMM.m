function get_universalGMM(path_features, people_train, all_people, actions,  K, dim, n_iterGMM)


scale = 1;
shift = 0;
path_1 = strcat( path_features, 'scale', num2str(scale), '-shift', num2str(shift), '/');
        

max_n_vec_video = 20000;% (~aprox) %16.000*16(people_train) = 256.000

n_actions = size(actions,1);


X = [ ] ;


for p=1: length(people_train)
   
    person = all_people(people_train(p));
    person
    for act = 1:n_actions
        
        load_video_i=  strcat( path_1,person, '_', actions(act), '_dim', num2str(dim), '.h5');
        S = char(load_video_i);
        vectors_one_video= hdf5info(S);
        Xi = hdf5read(data_one_cov.GroupHierarchy.Datasets(1)); % One covariance point
        a=1;
        b = length(Xi);
        random_points = randi([a b],1,max_n_vec_video);
        uni_points = unique(random_points);
        
        Xi_small = Xi(:,uni_points);
        X = [ X Xi_small];        
    end
   
end


disp('GMM');
tic
[means, covariances, priors] = vl_gmm(X, K,  'MaxNumIterations', n_iterGMM);
toc

%save_gmm_model =  strcat( './',GMM_folder, '/gmm_model_K', num2str(K), '_dim',num2str(dim) );
%save(char(save_gmm_model), 'means','covariances','priors');