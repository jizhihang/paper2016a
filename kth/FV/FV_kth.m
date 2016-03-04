%NICTA && Server
clear all
close all
clc

dbstop error;
dbstop in  get_universalGMM at 14

%VL
run('/home/johanna/toolbox/vlfeat-0.9.20/toolbox/vl_setup');

%Fisher Vector
addpath('/home/johanna/toolbox/yael/matlab');

%General paths
path  = '~/codes/codes-git/paper2016a/trunk/kth/';

%This path is only to load the matrices that contain all the feature vectors
%per video and their labels. 
path_features = '/home/johanna/codes/codes-git/manifolds/trunk/kth/dim_14/features/kth-features_dim14_openMP/sc1/';


dim = 14;
Ncent = 256;

Ng = int2str(Ncent);

actions = importdata('actionNames.txt');
all_people = importdata('people_list.txt');


n_peo =  size(all_people,1);

%n_test = (n_peo-1)*n_actions;
dim_FV = 2*dim*Ncent;

people_test =  [ 2 3 5  6  7  8  9  10 22 ];
people_train = [ 1 4 11 12 13 14 15 16 17 18 19 20 21 23 24 25];

get_universalGMM(path_features, people_train, all_people, actions,  K, dim, n_iterGMM)

