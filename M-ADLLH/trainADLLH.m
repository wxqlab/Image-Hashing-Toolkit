function [Btrain,Btest,Ytrain] = trainADLLH(Xtrain,Xtest,Ytrain,param)

addpath('./C-Utils/');

%% parameter settings
bit = param.bit;
param.DLLH_method = 'ADLLE';

%% center the data
data = [Xtrain;Xtest];
sampleMean = mean(data,1);
Xtrain = (Xtrain - repmat(sampleMean,size(Xtrain,1),1));
Xtest = (Xtest - repmat(sampleMean,size(Xtest,1),1));

%% 因为内存不足，随机选择10,000张图像作为训练数据
switch(param.dataset)
    case 'cifar_db_test_relu7'
        tmp = randperm(size(Xtrain,1));
        Xtrain = Xtrain(tmp(1:10000),:);
        Ytrain = Ytrain(tmp(1:10000),:);
    case 'nus_db_test_relu7'
        tmp = randperm(size(Xtrain,1));
        Xtrain = Xtrain(tmp(1:10000),:);
        Ytrain = Ytrain(tmp(1:10000),:);
end

%% train DLLH model
switch(param.DLLH_method)
    case 'DLLE'
        K = 10;
        alpha = 1;
        s_itr = 2;
        b_itr = 100;
        % PCA
        [pc, l] = eigs(cov(Xtrain),bit);
        S = getSimilarMatrix(Xtrain',K);
        Xtrain = Xtrain * pc;
        [Y,R] = DLLE2(Xtrain,S,b_itr,s_itr,alpha);
        Btrain = Xtrain*R > 0;
        Btrain = compactbit(Btrain);
        Xtest = Xtest * pc;
        Btest = Xtest*R > 0;
        Btest = compactbit(Btest);
    case 'ADLLE'
        K = 10;
        alpha = 1;
        s_itr = 2;
        b_itr = 100;
        % PCA
        [pc, l] = eigs(cov(Xtrain),bit);
        S = getAnchorW(Xtrain, Xtrain(randperm(size(Xtrain,1),300),:),2);
        Xtrain = Xtrain * pc;
        [Y,R] = DLLE2(Xtrain,S,b_itr,s_itr,alpha);
        Btrain = Xtrain*R > 0;
        Btrain = compactbit(Btrain);
        Xtest = Xtest * pc;
        Btest = Xtest*R > 0;
        Btest = compactbit(Btest);
end

end