function [Btrain,Btest] = trainRSSH(Xtrain,Xtest,param)
% =========================================================================
% RSSH: Recovery of Subspace Structures
% Unsupervised hashing based on the recovery of subspace structures --
% Pattern Recognition 2020
% =========================================================================
addpath('./C-Utils/');
test_data = Xtest;
train_data = Xtrain;
%% parameter settings
sigma = 0.4;
r = 100;
beta = 1e-1;
lambda = 10;
eta = 1e-3;
epchos = 5;
b = param.bit;

%% kernel computing
train_data_kernel = normr(train_data);
test_data_kernel = normr(test_data);
% get anchors
Ntrain = size(train_data,1);
Ntest = size(test_data,1);
n_anchors = min(Ntrain,2000);
rand('seed',7);
anchor = train_data_kernel(randsample(Ntrain, n_anchors),:);
Phi_testdata = exp(-sqdist_rssh(test_data_kernel,anchor)/(2*sigma*sigma));
Phi_testdata = [Phi_testdata, ones(Ntest,1)];
Phi_traindata = exp(-sqdist_rssh(train_data_kernel,anchor)/(2*sigma*sigma));
Phi_traindata = [Phi_traindata, ones(Ntrain,1)];
train_data_kernel = Phi_traindata;
test_data_kernel = Phi_testdata;

%% compute U,V
[U,V] = MF((train_data)',r);
[n,d] = size(train_data_kernel);
% Initialization
randn('seed',7);
G = randn(n,b);
% A = G;
B = sgn(G);

train_data = train_data_kernel;
test_data = test_data_kernel;

[W,B] = RSSH(train_data,B,G,lambda,beta,eta,b,epchos,U,V);

Btrain = B;
Btrain(Btrain<0) = 0;
Btrain = compactbit(Btrain);

Btest = sgn(test_data*W);
Btest(Btest<0) = 0;
Btest = compactbit(Btest);

end