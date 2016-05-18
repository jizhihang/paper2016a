%% Demo to compute P-CNN
% Report bugs to guilhem.cheron@inria.fr
%
% 
% ENABLE GPU support (in my_build.m) and MATLAB Parallel Pool to speed up computation (parpool) 


dbstop error;
dbstop in compute_Pcnn at 59
%%WANDA
addpath('/home/johanna/toolbox/BroxOpticalFlow_2004');
addpath('/home/johanna/toolbox/pose/features_for_videos/P-CNN-master');
dataset_path = '/home/johanna/codes/datasets_codes/MissUniverse_Pcnn/';
toolbox_path = '/home/johanna/toolbox/pose/features_for_videos/P-CNN-master/';
matconvpath = '/home/johanna/toolbox/pose/features_for_videos/P-CNN-master/matconvnet-1.0-beta11'; % MatConvNet

%% Home
%addpath('/media/johanna/HD1T/Toolbox/BroxOpticalFlow2004/eccv2004Matlab');
%addpath('/media/johanna/HD1T/Toolbox/Pose/video_features/P-CNN-master');
%dataset_path = '/media/johanna/HD1T/codes/datasets_codes/MissUniverse_Pcnn/';
%toolbox_path = '/media/johanna/HD1T/Toolbox/Pose/video_features/P-CNN-master/';

%matconvpath = '/media/johanna/HD1T/Toolbox/Pose/video_features/P-CNN-master/matconvnet-1.0-beta11'; % MatConvNet



%%
run([matconvpath '/my_build.m']); % compile: modify this file to enable GPU support (much faster)
run([matconvpath '/matlab/vl_setupnn.m']) ; % setup  


%% P-CNN computation
% ----- PARAMETERS --------
param=[];
param.lhandposition=7; % pose joints positions in the structure (JHMDB pose format)
param.rhandposition=19;
param.upbodypositions=[1 2 3 4 5 6 7 8 9 10 15 16 17 18 19 20 21 22];
param.lside = 120 ; % length of part box side (also depends on the human scale)
param.savedir = [ dataset_path 'features']; % P-CNN results directory
param.impath = [dataset_path 'images']; % input images path (one folder per video)
param.imext = '.jpg' ; % input image extension type
param.jointpath = [ dataset_path 'joint_positions']; % human pose (one folder per video in which there is a file called 'joint_positions.mat')
param.trainsplitpath = [dataset_path 'splits/MU_train.txt']; % split paths
param.testsplitpath =  [dataset_path 'splits/MU_test.txt'];
param.cachepath = 'cache'; % cache folder path
param.net_app  = load([toolbox_path '/models/imagenet-vgg-f.mat']) ; % appearance net path
param.net_flow = load([ toolbox_path '/models/flow_net.mat']) ; % flow net path
param.batchsize = 128 ; % size of CNN batches
param.use_gpu = false ; % use GPU or CPUs to run CNN?
param.nbthreads_netinput_loading = 20 ; % nb of threads used to load input images
param.compute_kernel = false ; % compute linear kernel and save it. If false, save raw features instead.


% get video names
video_names = dir(param.impath);
video_names={video_names.name};
video_names=video_names(~ismember(video_names,{'.','..'}));

if ~exist(param.cachepath,'dir'); mkdir(param.cachepath) ; end % create cache folder

% 1 - pre-compute OF images for all videos
%compute_OF(video_names,param); % compute optical flow between adjacent frames

% 2 - extract part patches
%my_scale = 1;
%my_extract_cnn_patches(video_names,param,my_scale)

% 3 - extract CNN features for each patch and group per video
%extract_cnn_features(video_names,param)

% 4 - compute final P-CNN features + kernels
compute_pcnn_features(param); % compute P-CNN for split 1



