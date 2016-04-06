function save_bb_images

view = 1;

%UQ
path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';
path_pcnn = '/home/johanna-uq/codes/datasets_codes/MissUniverse_Pcnn';

%wanda
path_dataset  = '/home/johanna/codes/datasets_codes/MissUniverse/';
path_pcnn =  '/home/johanna/codes/datasets_codes/MissUniverse_Pcnn/';
 

all_years = [ 2010 ];
all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];


n_years = length(all_years);

for y=1:n_years
    
    fprintf('Processing Miss Universe %d \n', all_years(y));

    
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    save_BB(path_dataset, year, countries, view, path_pcnn) 
    
   
end




function save_BB(path_dataset, year, countries, view, path_pcnn ) 
 
   n_countries = length(countries);
    
    
    for c = 1:n_countries
        
        folder_pcnn = strcat(path_pcnn, '/MissUniverse', year,'/', countries(c), '-', num2str(view),'/');
        
        if ~exist( char(folder_pcnn) )    
            mkdir( char(folder_pcnn) );
        end
 
 
        bb_path =  strcat(path_dataset, 'MissUniverse', year, '/', countries(c), '-', num2str(view), '/BB_all_frames.txt');
        BB_list = importdata( char(bb_path) );

        country_folder = strcat(path_dataset, 'MissUniverse', year, '/', countries(c), '-', num2str(view),'/*.jpg');
        imlist = dir(char(country_folder));
        for i = 1:length(imlist)
            % load and display image
            frame_name =  strcat(path_dataset, 'MissUniverse', year, '/', countries(c), '-', num2str(view),'/', imlist(i).name);
            im = imread( char(frame_name) );
            %imagesc(im); 
            %hold on
            %rectangle('Position', BB_list(i,:), 'EdgeColor','r', 'LineWidth', 3)
            rect = BB_list(i,:);
            cropped_im= imcrop(im,rect);
            BB_im = imresize(cropped_im,[100 50], 'nearest');
            %imagesc(BB_im);
            %truesize
            %drawnow;
            %pause(0.01); % Wait 1/2 second to show each one.
            imwrite(BB_im, [char(folder_pcnn)  imlist(i,1).name ]);
        end
        close all
        
    end

