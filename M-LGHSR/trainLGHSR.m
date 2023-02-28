function [Btrain,Btest] = trainLGHSR(Xtrain,Xtest,param)
% =========================================================================
% LGHSR: Large Graph Hashing with Spectral Rotation
% Large graph hashing with spectral rotation -- AAAI 2017
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.s = 3;
param.anchor = 300;

%% train LGHSR
% get anchor
anchor_nm = ['anchor_' num2str(param.anchor)];
eval(['[~,' anchor_nm '] = litekmeans(Xtrain, param.anchor, ''MaxIter'', 10);']);
eval(['anchor_set.' anchor_nm '= ' anchor_nm, ';']);
eval(['anchor = anchor_set.' anchor_nm ';']);

% get hash code
[Y, W, F, Z, sigma] = raw_sh(Xtrain, anchor, param.bit, param.s, 0);
tY = OneLayerAGH_Test(Xtest, anchor, W, param.s, sigma);
Btrain = compactbit(Y);
Btest = compactbit(tY);

end