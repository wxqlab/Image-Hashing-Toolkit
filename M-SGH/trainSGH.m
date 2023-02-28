function [Btrain,Btest] = trainSGH(Xtrain,Xtest,param)
% =========================================================================
% SGH: Scalable Graph Hashing
% Scalable graph hashing with feature transformation -- IJCAI 2015
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
Mean = mean(Xtrain);
trainX = bsxfun(@minus, Xtrain, Mean);
testX = bsxfun(@minus, Xtest, Mean);

train_norm = sqrt(sum(trainX.*trainX, 2));
trainX = bsxfun(@rdivide, trainX, train_norm);

test_norm = sqrt(sum(testX.*testX, 2));
testX = bsxfun(@rdivide, testX, test_norm);

param.m = 300;
param.rho = 2;
num_training = size(trainX,1);
sample = randperm(num_training);
bases = trainX(sample(1:param.m),:);

%% train SGH model
[Wx,KXTrain,para] = SGH(trainX, bases, param.bit, param.rho);

Btrain = compactbit(KXTrain*Wx > 0);

num_testing = size(testX,1);
KTest = distMat(testX,bases);
KTest = KTest.*KTest;
KTest = exp(-KTest/(2*para.delta));
KXTest = KTest-repmat(para.bias,num_testing,1);

Btest = compactbit(KXTest*Wx > 0);

end