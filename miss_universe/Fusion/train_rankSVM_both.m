function train_rankSVM_both(params, params_svm,  svm_type)


path_dataset = params.path_dataset;
project_path = params.project_path;
view = params.view;
years_train = params.years_train;
K = params.K;
dim_SFV = params.dim_SFV;
dim_FV = params.dim_FV;

FV_folder_ly2 = params.FV_folder_ly2;
run = params.run;
FV_folder = params.FV_folder;



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


load_pca_data = strcat('./projected_points/pca_projection_data_run', num2str(run));
load(char(load_pca_data),'W', 'NP');


X_train = zeros( NP,  n_comparisons ); % NP dim after PCA
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
        
        %SFV
        load_FV =  strcat(project_path, '/SFV_Np14/', FV_folder_ly2, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        SFV1 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
        
        %FV
        load_FV =  strcat(project_path, '/FV/', FV_folder, '/MissUniverse', year, '/', countries(c), '_view', num2str(view), '_run', num2str(run),'.h5' );
        S = char(load_FV);
        FV_one_video= hdf5info(S);
        FV1 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
        
        
        V1 = [FV1; SFV1];
        V1 = V1'*W; %PCA
        
        
        %for c2 = 1 : n_countries %case A
        for c2 = c + 1 : n_countries %case B
                 
                %SFV
                load_FV =  strcat(project_path, '/SFV_Np14/', FV_folder_ly2, '/MissUniverse', year, '/', countries(c2),  '_view', num2str(view) , '_run', num2str(run) ,'.h5' );
                S = char(load_FV);
                FV_one_video= hdf5info(S);
                SFV2 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
                
                %FV
                load_FV =  strcat(project_path, '/FV/', FV_folder, '/MissUniverse', year, '/', countries(c2),  '_view', num2str(view) , '_run', num2str(run) ,'.h5' );
                S = char(load_FV);
                FV_one_video= hdf5info(S);
                FV2 = hdf5read(FV_one_video.GroupHierarchy.Datasets(1)); 
                
                V2 = [FV2; SFV2];
                V2 = V2'*W; %PCA
                
                X_train(:,j) = V1-V2;
                
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
   

if ~exist('svm_models', 'dir')
    mkdir('svm_models');
end



if strcmp( svm_type, 'linear')
    %svm_type
    sparse_X_train =  sparse(X_train');
    model = train(labels_train, sparse_X_train, [params_svm]);
    save_svm_model = strcat( './svm_models', '/concFV_SFV_K', num2str(K), '_view', num2str(view), '_run', num2str(run), '.mat');
    save(save_svm_model, 'model');
end