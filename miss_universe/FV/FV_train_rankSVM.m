function FV_train_rankSVM(path_dataset, view, years_train, K, dim_FV, FV_folder, svm_folder, svm_type, params, run)


n_years = length(years_train);

n_samples_train = 0;
n_comparisons = 0;
for y=1:n_years
    year = num2str( years_train(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    countries = importdata(load_year_list);
    n_countries = length(countries);
    n_samples_train = n_samples_train + n_countries;
    %n_comparisons = n_comparisons + n_countries*(n_countries-1);%case A 
    n_comparisons = n_comparisons + nchoosek(n_countries,2);%case B
   
end


X_train = zeros( dim_FV,  n_comparisons );
labels_train = zeros(n_comparisons,1);
n_labels_train = zeros(n_comparisons,2);
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
    
    
    
    for c = 1:n_countries
        
        load_FV =  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        FV1 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
        
        %for c2 = 1 : n_countries %case A
        for c2 = c + 1 : n_countries %case B
         
                load_FV =  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c2),  '_view', num2str(view) , '_run', num2str(run) ,'.h5' );
                S = char(load_FV);
                FV_one_video= hdf5info(S);
                FV2 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
                
                
                
                
                X_train(:,j) = FV1-FV2;
                
                n_labels_train (j,1)  = c;
                n_labels_train (j,2)  = c2;
                
                if (scores(c)>scores(c2))
                    
                    labels_train(j) = 1;
                else
                    labels_train(j) = -1;
                end
                
                j = j + 1;
        end
    end
end

if strcmp( svm_type, 'linear')
    %svm_type
    sparse_X_train =  sparse(X_train');
    model = train(labels_train, sparse_X_train, [params]);
    save_svm_model = strcat( './', svm_folder, '/libLinear_FV_K', num2str(K), '_view', num2str(view), '_run', num2str(run), '.mat');
    save(save_svm_model, 'model');
end
      

if strcmp( svm_type, 'svm')

    data_train = X_train';
    model = svmtrain(labels_train, data_train, [params]);
    save_svm_model = strcat( './',svm_folder, '/FV_K', num2str(K), '_view', num2str(view) , '_run', num2str(run), '.mat');
    save(save_svm_model, 'model');
end