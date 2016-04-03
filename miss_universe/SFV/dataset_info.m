


%Path for Original dataset

%WANDA
%path_dataset  = '/home/johanna/codes/datasets_codes/MissUniverse/';

%UQ
path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';


all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];

dataset_description = cell{105,3};


for y=1:length(all_years)
    
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    n_countries = length(countries);
    
    
    for c=1:n_countries
         load_year_list =  strcat(path_dataset, 'MissUniverse', year, countries(c), '-', num2str(1), '/list.txt');
         frame_list = importdata(load_year_list);
         
        length(frame_list)
        
        
    end
    
    
    
    
    
end
    


