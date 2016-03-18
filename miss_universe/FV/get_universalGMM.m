function get_universalGMM(path_dataset, path_features, view, years_train,  K,  n_iterGMM, GMM_folder)

n_years = length(years_train);
%%See how many vectors there are per video
max_n_vec_video = 6000; % To randomly select ~ 256.000

X = [ ] ;


for y=1:n_years
   
    year = num2str( years_train(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    
    for c = 1:n_countries
        load_video_i=  strcat( path_features, 'MissUniverse', year, '/', countries(c), '_view', num2str(view), '.h5');
        S = char(load_video_i);
        vectors_one_video= hdf5info(S);
        Xi = hdf5read(vectors_one_video.GroupHierarchy.Datasets(1)); % One covariance point
        %size(Xi)
        %pause
        
        a=1;
        b = length(Xi);
        random_points = randi([a b],1,max_n_vec_video);
        uni_points = unique(random_points);
        
        Xi_small = Xi(:,uni_points);
        X = [ X Xi_small];  
       
    end

end

%size(X)

disp('GMM')
tic
[means, covariances, priors] = vl_gmm(X, K,  'MaxNumIterations', n_iterGMM);
toc

save_gmm_model =  strcat( './',GMM_folder, '/gmm_model_K', num2str(K), '_view', num2str(view) );
save(char(save_gmm_model), 'means','covariances','priors');