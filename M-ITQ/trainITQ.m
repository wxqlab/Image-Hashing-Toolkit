function [Btrain,Btest] = trainITQ(Xtrain,Xtest,param)
% =========================================================================
% ITQ: Iterative Quantization 
% terative quantization: A procrustean approach to learning binary codes
% for large-scale image retrieval -- T-PAMI 2013 (CVPR 2011)
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.ites = 50;

%% train ITQ model
dim = size(Xtrain,2);
if (param.bit > dim)
    fprintf('the bit num for ITQ must no greater than dim\n');
    return;
end

% PCA
[pc, ~] = eigs(cov(Xtrain),param.bit);
Xtrain_pc = Xtrain * pc;

% train
[~, R] = ITQ(Xtrain_pc,param.ites);
R = pc * R;

Y = (Xtrain*R >=0);
tY = (Xtest*R >= 0);
Btrain = compactbit(Y);
Btest = compactbit(tY);

end