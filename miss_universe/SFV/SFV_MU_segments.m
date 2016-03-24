% UQ && Server (WANDA) && Home
clear all
close all
clc

dbstop error;
%dbstop in  get_universalGMM at 14
%dbstop in FV_layers_1 at 89
dbstop in dim_reduction at 41

%%Setting paths for libs and features and original dataset
pc = 'wanda'; % uq wanda home
svm_type = 'linear'; %'svm';    %libsvm
[path_dataset path_features] = set_paths(pc, svm_type);

%MU_years = importdata('miss_universe_list.txt');

all_years = [  2010 2007 2003 2002 2001 ];

prompt = 'K? ';
K = input(prompt);


%Parameters 
vec_c = [ 0.1 1 10 100];
%vec_c = [ 10 ] ;

segm_length = 5;
n_iterGMM = 10; % For GMM


main_FV_layer1(path_dataset, path_features, all_years, K, svm_type, vec_c, segm_length, n_iterGMM  )








