function [Btrain,Btest] = trainLSH(Xtrain,Xtest,param)
 % =========================================================================
% LSH: Locality Sensitive Hashing
% Locality-sensitive hashing scheme based on p-stable distributions -- SCG
% '04: Proceedings of the twentieth annual symposium on Computational
% geometry 2004
% =========================================================================
%% get hash code
addpath('./C-Utils/');
dim = size(Xtrain,2);
nbit = param.bit;
W = randn(dim, nbit);

Y = Xtrain * W > 0;
tY = Xtest * W > 0;
Btrain = compactbit(Y);
Btest = compactbit(tY);

end