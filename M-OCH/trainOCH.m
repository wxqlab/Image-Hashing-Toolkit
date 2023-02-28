function [Btrain,Btest] = trainOCH(Xtrain,Xtest,param)
% =========================================================================
% OCH: Ordinal Constraint Hashing 
% Ordinal constraint binary coding for approximate nearest neighbor search
% -- T-PAMI 2018
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.maxIter = 300;
param.L = 300;
param.beta = 1;
param.lamda = 0.01;
param.alph = 0.1;
param.k = 10;
param.dimD = 20;

num_training = 10000;
rand_num = randperm(size(Xtrain,1));
traindata = Xtrain(rand_num(1:num_training),:);

%% train OCH model
[R, eigVec, sample_mean] = OCH(traindata,param);

Btrain = compressOCH(Xtrain, R, eigVec, sample_mean);

Btest = compressOCH(Xtest, R, eigVec, sample_mean);

end