
%% =================================================================
% This is the main script for evaluating the image retrieval performance.
% This codes are compiled by Xiaoqin Wang
% Time: October,1-30,2020
%% =================================================================

clear,clc
close all

%% input methods
param.methods = {'JPSH', 'CH', 'RSSH', 'JSH', 'LGHSR', 'ADLLH', 'OCH', 'OEH', 'SGH', 'SP', 'IMH', 'ITQ', 'AGH', 'SH', 'LSH', 'KNNH', 'CBE', 'DSH'}; 

%% input bits
param.bits = [8 16 32 64 96 128];

%% input datasets
param.datasets = {'MNIST', 'CIFAR-10', 'FLICKR25K', 'NUS-WIDE'}; 

%% test retrieval method
param.runtimes = 10;
save_path = 'Results/';
test_models(param,save_path);

%% show the retrieval results
visualize_results(param,save_path)
