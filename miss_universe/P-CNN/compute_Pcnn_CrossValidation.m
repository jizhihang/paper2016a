%% Demo to compute P-CNN
% Report bugs to guilhem.cheron@inria.fr
%
% 
% ENABLE GPU support (in my_build.m) and MATLAB Parallel Pool to speed up computation (parpool) 

clear all
clc
dbstop error;
%dbstop in compute_Pcnn at 59
dbstop in my_compute_pcnn_features at 107

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

param.impath = [dataset_path 'images']; % input images path (one folder per video)
param.imext = '.jpg' ; % input image extension type
param.jointpath = [ dataset_path 'joint_positions']; % human pose (one folder per video in which there is a file called 'joint_positions.mat')
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

all_years = [ 2010 2007 2003 2002 2001 2000 1999 1998 1997 1996 ];


% compute P-CNN for one split. 
%I doesn't make sense. 
%Just run one time

run =1;
savedir = [ dataset_path 'features/features_' num2str(all_years(run))]; % P-CNN results directory
param.trainsplitpath = [dataset_path 'splits/MU_train_' num2str(run) '.txt']; % split paths
param.testsplitpath =  [dataset_path 'splits/MU_test_'  num2str(run) '.txt'];
%my_compute_pcnn_features(param); 
save_pcnn_vectors(param);



%for run=1:10
%param.savedir = [ dataset_path 'features/features_' num2str(all_years(run))]; % P-CNN results directory
%param.trainsplitpath = [dataset_path 'splits/MU_train_' num2str(run) '.txt']; % split paths
%param.testsplitpath =  [dataset_path 'splits/MU_test_'  num2str(run) '.txt'];
%end



