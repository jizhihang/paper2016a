


%Path for Original dataset

%WANDA
%path_dataset  = '/home/johanna/codes/datasets_codes/MissUniverse/';

%UQ
path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';


all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];

dataset_description = cell(105,3);
 k =1;

for y=1:length(all_years)
    
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    
    for c=1:n_countries
         load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/', countries(c), '-', num2str(1), '/list.txt');
         frame_list = importdata( char(load_year_list) );
         
        
        dataset_description(k,1) =  {year};
        dataset_description(k,2) =  countries(c); 
        dataset_description(k,3) =  {length(frame_list)};
        k = k+1;
        
    end
    

end

num_frames = cell2mat( dataset_description(:,3) );
    


