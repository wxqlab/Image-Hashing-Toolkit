function [Btrain,Btest] = trainCBE(Xtrain,Xtest,param)
% =========================================================================
% CBE: Circulant Binary Embedding
% Circulant binary embedding -- In International conference on machine
% learning (ICML 2014)
% =========================================================================

%% train CBE model
addpath('./C-Utils/');
param.method = 'CBE-rand';
[B1,B2] = CBE(Xtrain,Xtest,param);
Btrain = compactbit(B1>0);
Btest = compactbit(B2>0);

end