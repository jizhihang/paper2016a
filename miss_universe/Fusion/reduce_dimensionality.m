function reduce_dimensionality(params)


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

n_samples = 0;

for y=1:n_years
    year = num2str( years_train(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    countries = importdata(load_year_list);
    n_countries = length(countries);
    n_samples = n_samples + n_countries;
       
end


X_train = zeros( dim_FV + dim_SFV,  n_samples );
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
        X_train(:,j) = V1;
         j = j + 1;

    end
end


if ~exist('projected_points', 'dir')
    mkdir('projected_points');
end



Sigma=cov(X_trainX');
[U,S,V] = svd(Sigma);
NP = dim_FV; % Both has the same dimensionality. Reducing by a factor of 2

W = U(:,1:NP);


save_rp_data = strcat('./projected_points/pca_projection_data_run', num2str(run))
save(char(save_rp_data),'W', 'NP');

