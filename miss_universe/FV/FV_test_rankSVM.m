function [predicted_output, accuracy,  dec_values, labels_test]  = FV_test_rankSVM(path_dataset, view, years_test, K, dim, dim_FV, FV_folder, svm_folder, run)

load_svm_model = strcat( './',svm_folder, '/FV_K', num2str(K), '_view', num2str(view), '_run', num2str(run), '.mat');
load(load_svm_model, 'model');

n_years = length(years_test);
n_samples_test = 0;

for y=1:n_years
    year = num2str( years_test(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    countries = importdata(load_year_list);
    n_countries = length(countries);
    n_samples_test = n_samples_test + n_countries;
end


X_test = zeros(dim_FV, n_samples_test*(n_samples_test-1) );
labels_test = zeros(n_samples_test*(n_samples_test-1),1);
j = 1;


for y=1:n_years
    
    year = num2str( years_test(y) );
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
        
        
        for c2 = 1 : n_countries
            
            if (c~=c2)
                
                load_FV =  strcat('./', FV_folder, '/MissUniverse', year, '/', countries(c2), '_view', num2str(view), '_run', num2str(run),'.h5' );
                S = char(load_FV);
                FV_one_video= hdf5info(S);
                FV2 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
                
                X_test(:,j) = FV1-FV2;
                
                if (scores(c)>scores(c2))
                    
                    labels_test(j) = 1;
                else
                    labels_test(j) = -1;
                end
                
                j = j + 1;
                
                
            end
        end
        
        
    end
end

[predicted_output, accuracy, dec_values] = svmpredict(labels_test, X_test', model);