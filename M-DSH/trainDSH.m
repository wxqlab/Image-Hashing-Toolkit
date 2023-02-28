function [Btrain,Btest] = trainDSH(Xtrain,Xtest,param)
% =========================================================================
% DSH: Density Sensitive Hashing
% Density sensitive hashing -- IEEE transactions on cybernetics (2014)
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.r = 3;
param.iter = 3;
param.alpha = 1.5;

%% train DSH model
[model, Y, elapse] = DSH_learn(Xtrain, param);
[tY, elapse] = DSH_compress(Xtest, model);
Btrain = compactbit(Y);
Btest = compactbit(tY);

end