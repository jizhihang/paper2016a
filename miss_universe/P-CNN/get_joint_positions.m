function get_joint_positions


view = 1;

%% UQ
%path_dataset  = '/home/johanna-uq/codes/datasets_codes/MissUniverse/';
%path_pcnn = '/home/johanna-uq/codes/datasets_codes/MissUniverse_Pcnn/';
%path_pcnn_joints ='/home/johanna-uq/codes/datasets_codes/MissUniverse_Pcnn/joint_positions/';

%% wanda
%Pose_Code:
path_pose_code ='/home/johanna/toolbox/pose/images/pami2013/pose_v1.3/code-basic/';
path_dataset  = '/home/johanna/codes/datasets_codes/MissUniverse/';
path_pcnn =  '/home/johanna/codes/datasets_codes/MissUniverse_Pcnn/';
path_pcnn_joints ='/home/johanna/codes/datasets_codes/MissUniverse_Pcnn/joint_positions/';

%% home
%Pose_Code:
%path_pose_code = '/media/johanna/HD1T/Toolbox/Pose/images/pose_v1.3/code-basic/';

%path_dataset = '/media/johanna/HD1T/codes/datasets_codes/MissUniverse/';
%path_pcnn = '/media/johanna/HD1T/codes/datasets_codes/MissUniverse_Pcnn/images/';
%path_pcnn_joints = '/media/johanna/HD1T/codes/datasets_codes/MissUniverse_Pcnn/joint_positions/';

%%

all_years = [ 2010 ];
%all_years = [  2010 2007 2003 2002 2001 2000 1999 1998 1997 1996];


n_years = length(all_years);

for y=1:n_years
    
    fprintf('Getting Joint Positions for Miss Universe %d \n', all_years(y));
    
    
    year = num2str( all_years(y) );
    load_year_list =  strcat(path_dataset, 'MissUniverse', year, '/country_list.txt');
    
    countries = importdata(load_year_list);
    human_pose_estimation(year, countries, view, path_pcnn,path_pcnn_joints, path_pose_code)
    
    
end




function human_pose_estimation(year, countries, view, path_pcnn,path_pcnn_joints, path_pose_code )

warning off
addpath(path_pose_code);
addpath( [path_pose_code 'visualization'] );
if isunix()
  addpath ( [path_pose_code 'mex_unix'] );
elseif ispc()
  addpath ( [path_pose_code 'mex_pc'] );
end

run([path_pose_code 'compile']);
load('PARSE_model');
n_countries = length(countries);


for c = 1:n_countries
    
    folder_pcnn_joints = strcat(path_pcnn_joints, '/MissUniverse', year,'/', countries(c), '-', num2str(view),'/');
     folder_pcnn = strcat(path_pcnn, '/MissUniverse', year,'/', countries(c), '-', num2str(view),'/');
    
    if ~exist( char(folder_pcnn_joints) )
        mkdir( char(folder_pcnn_joints) );
    end
    
    country_folder = strcat(path_pcnn, 'MissUniverse', year, '/', countries(c), '-', num2str(view),'/*.jpg');
    imlist = dir(char(country_folder));
    
    numparts = 26; %As pr paper description
    pos_img = zeros(2,numparts,length(imlist));
    for i = 1:length(imlist)
        % load and display image
        
        %[char(folder_pcnn)  imlist(i,1).name ]
        im = imread( [char(folder_pcnn)  imlist(i,1).name ] );
        clf; 
        %imagesc(im); 
        %axis image; 
        %axis off; 
        %drawnow;
        
        % call detect function
        tic;
        boxes = detect_fast(im, model, min(model.thresh,-1));
        dettime = toc; % record cpu time
        boxes = nms(boxes, .1); % nonmaximal suppression
        colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
        if  size(boxes) == [0,0]
            %[char(folder_pcnn)  imlist(i,1).name ]
            %size(boxes) 
            pos_img(:,:,i) = pos_img(:,:,i-1);
        else            
        pos_img(:,:,i) = my_showboxes(im, boxes(1,:),colorset); % show the best detection
        end
        
        %showboxes(im, boxes,colorset);  % show all detections
        %fprintf('detection took %.1f seconds\n',dettime);
        %disp('press any key to continue');
        %pause(0.01);
    end
    [char(folder_pcnn_joints) joint_positions ]
    save([char(folder_pcnn_joints) joint_positions ],'pos_img' );
    
    %close all
    
end

