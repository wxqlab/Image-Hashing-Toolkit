function [Btrain,Btest] = trainSP(Xtrain,Xtest,param)
% =========================================================================
% SP: Sparse Projections
% Sparse projections for highdimensional binary codes -- CVPR 2015
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.maxIte = 50;
param.sparsity = 0.9;

%% train SP model
R = SP(Xtrain, param.bit, param.sparsity, param.maxIte);
Y = (Xtrain*R' >= 0);
tY = (Xtest*R' >= 0);
Btrain = compactbit(Y);
Btest = compactbit(tY);

end