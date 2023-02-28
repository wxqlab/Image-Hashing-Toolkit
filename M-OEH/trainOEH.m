function [Btrain,Btest] = trainOEH(Xtrain,Xtest,param)
% =========================================================================
% OEH: Ordinal Embedding Hashing
% Towards Optimal Binary Code Learning via Ordinal Embedding -- AAAI 2016
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
switch(param.dataset)
    case 'CIFAR-10'
        param.maxIter = 300;
        param.L = 300;
        param.k = 10;
        param.lamda = 0.001;
        param.beta = 1.5;
        param.alph = 0.1;
        param.dimD = param.bit;
    otherwise
        param.maxIter = 300;
        param.L = 300;
        param.k = 10;
        param.lamda = 0.01;
        param.beta = 1;
        param.alph = 0.1;
        param.dimD = param.bit;
end

train_num = 10000;
rp = randperm(size(Xtrain,1));
traindata = Xtrain(rp(1:train_num),:);

%% train OEH model
[ R, eigVec, sample_mean] = OEH(traindata, param);

Btrain = compressOEH(Xtrain, R, eigVec, sample_mean);

Btest = compressOEH(Xtest, R, eigVec, sample_mean);

end