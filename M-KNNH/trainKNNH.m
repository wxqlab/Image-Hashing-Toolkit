function [Btrain,Btest] = trainKNNH(Xtrain,Xtest,param)
% =========================================================================
% K-Nearest Neighbors Hashing -- CVPR 2019
% =========================================================================

train_features = double(Xtrain');
query_features = double(Xtest');

gpuDevice_ID = 1; % if CPU-only / you don't want to use GPU, just set it as -1
use_gpu = check_gpu(gpuDevice_ID);

param.K = 20; % 200 for Places205
param.times = 1;
param.gpu = use_gpu;
num_bits = param.bit;

% zero-mean
avg = mean(train_features, 2);
X = bsxfun(@minus, train_features, avg);
Q = bsxfun(@minus, query_features, avg);
% Preprocess data to remove correlated features.
Xcov = X*X';
Xcov = (Xcov + Xcov')/(2*size(X, 2));
[U,S,~] = svd(Xcov);

if (strcmp(dataset, 'places'))
    param.idX = load_idX('./model/KNN_Places205.mat', use_gpu, K, X');
end
X_pca = U(:,1:num_bits)' * X; % d'*n
Q_pca = U(:,1:num_bits)' * Q;

[param] = KNNH(X_pca', param);
Btrain = testKNNH(X_pca', param, 0);
Btest  = testKNNH(Q_pca', param, 1);

end