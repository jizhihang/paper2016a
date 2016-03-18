function FV_train(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, params, top_n)


n_years = length(years_train);

n_samples_train = 0;

for y=1:n_years
    year = num2str( years_train(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    countries = importdata(load_year_list);
    n_countries = length(countries);
    n_samples_train = n_samples_train + n_countries;
end


X_train = zeros(dim_FV, n_samples_train);
labels_train = zeros(n_samples_train,1);
j = 1;


for y=1:n_years
   
    year = num2str( years_train(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    load_scores_list  =  strcat(path_dataset, 'MissUniverse', year, '/scores.txt');
    fileID = fopen(load_scores_list);
    countries_scores  = textscan(fileID,'%s %f');
    countries_2       = countries_scores{1};
    scores            = countries_scores{2};
    
    
    %scores';
    %nor_scores = ( scores - min(scores) ) / (max(scores)-min(scores));
    
    [sort_scores pos] = sort(scores, 'descend');
    nor_scores = zeros(1,n_countries);
   
    nor_scores( pos(1:top_n) ) = 1; % The first top_n higest scores = 1
    
    for c = 1:n_countries
        
        load_FV =  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        FVi = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); % One covariance point
        X_train(:,j) = FVi;
        
        if strcmp( countries(c), countries_2(c)) % Extra security measure
        
        labels_train(j) = nor_scores(c);
        j = j + 1;
        
        else
            disp('See what happens')
        end
    end
end




data_train = X_train';
model = svmtrain(labels_train, data_train, [params]);
save_svm_model = strcat( './',svm_folder, '/FV_K', num2str(K), '_view', num2str(view), '.mat');
save(save_svm_model, 'model');