
%% Only useful for Leave-One-Out Cross Validation
function [predicted_output, accuracy,  dec_values, labels_test, n_labels_test, scores, n_countries]  = test_rankSVM_both(params,  svm_type)

path_dataset = params.path_dataset;
project_path = params.project_path;
view = params.view;
years_test = params.years_test;
K = params.K;
dim_SFV = params.dim_SFV;
dim_FV = params.dim_FV;
FV_folder_ly2 = params.FV_folder_ly2;
FV_folder = params.FV_folder;

run = params.run;


n_years = length(years_test);
n_samples_test = 0;

n_comparisons = 0;


for y=1:n_years
    year = num2str( years_test(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    countries = importdata(load_year_list);
    n_countries = length(countries);
    n_samples_test = n_samples_test + n_countries;
    %n_comparisons = n_comparisons + n_countries*(n_countries-1);%case A
    n_comparisons = n_comparisons + nchoosek(n_countries,2);%case B
end


X_test = zeros(dim_FV + dim_SFV, n_comparisons );
labels_test = zeros(n_comparisons,1);
n_labels_test = zeros(n_comparisons,2);
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
        
        %SFV
        load_FV =  strcat(project_path,'/SFV/', FV_folder_ly2, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        SFV1 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
        
        %FV
        load_FV =  strcat(project_path, '/FV/', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        FV1 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
        
        V1 = [FV1; SFV1];
        
        
        %for c2 = 1 : n_countries %case A
           for c2 = c +1 : n_countries %case B  
          
                %SFV
                load_FV =  strcat(project_path, '/SFV/', FV_folder_ly2, '/MissUniverse', year, '/', countries(c2), '_view', num2str(view), '_run', num2str(run),'.h5' );
                S = char(load_FV);
                FV_one_video= hdf5info(S);
                SFV2 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
                
                
                %FV
                load_FV =  strcat(project_path, '/FV/', FV_folder, '/MissUniverse', year, '/', countries(c2), '_view', num2str(view), '_run', num2str(run),'.h5' );
                S = char(load_FV);
                FV_one_video= hdf5info(S);
                FV2 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
                
                V2 = [FV2; SFV2];
                
                X_test(:,j) = V1-V2;
                
                n_labels_test (j,1)  = c;
                n_labels_test (j,2)  = c2;
                
                if (scores(c)>scores(c2))
                    
                    labels_test(j) = 1;
                else
                    labels_test(j) = -1;
                end
                
                j = j + 1;
                
                
 
        end
        
        
    end
end

if strcmp( svm_type, 'svm')
    load_svm_model = strcat( './svm_models', '/FV_K', num2str(K), '_view', num2str(view), '_run', num2str(run), '.mat');
    load(load_svm_model, 'model');
    [predicted_output, accuracy, dec_values] = svmpredict(labels_test, X_test', model);
end

%% libLinear
if strcmp( svm_type, 'linear')
    load_svm_model = strcat( './svm_models',  '/concFV_SFV_K', num2str(K), '_view', num2str(view), '_run', num2str(run), '.mat');
    load(load_svm_model) % Loading  model obtained with libLinear
    sparse_X_test =  sparse(X_test');
    [predicted_output, accuracy, dec_values] = predict(labels_test,sparse_X_test , model);
end