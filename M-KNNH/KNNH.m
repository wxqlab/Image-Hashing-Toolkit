function [param] = KNNH(X, param)

% Input:
%          X: n*d, n is the number of images
%          KNNHparam:
%               KNNHparam.pcaW  : PCA projection
%               KNNHparam.nbits : encoding length
%               KNNHparam.K     : K in KNN
%               KNNHparam.times : iterations of KNN Shrinkage
%               KNNHparam.gpu   : use gpu or not
%               KNNHparam.idX   : Places205 precomputed index matrix
%               
% Output:
%          KNNHparam:
%               KNNHparam.pcaW  : PCA projection
%               KNNHparam.nbits : encoding length
%               KNNHparam.r     : KNNH linear projection
%               KNNHparam.B     : learned binary representation of the gallery set

if (isfield(param, 'pcaW') == 1)
    V = X*param.pcaW;
else
    V = X;
end
nbits = param.bit;
 
% initialize with a orthogonal random rotation

R = randn(nbits, nbits);
[U11, ~, ~] = svd(R);
R = U11(:, 1: nbits);

K = param.K;
% fprintf('K : %d.\n', K);

% KNN Search
if (isfield(param, 'idX') == 1)
    idX = param.idX; % Places205
else
    if (param.gpu == 1)
        V_GPU = gpuArray(V);
        tic;
        idX_GPU = knnsearch(V_GPU, V_GPU, 'K', K+1, 'Distance', 'euclidean');
        toc;
        idX = gather(idX_GPU);
        idX = idX(:,2:K+1);
    else
        tic;
        idX = knnsearch(V, V, 'K', K+1, 'Distance', 'euclidean');
        toc;
        idX = idX(:,2:K+1);
    end
end

% KNN Shrinkage
for times = 1:param.times
    for i = 1:size(idX, 1)
        V(i,:) = mean(V(idX(i,:),:));
        fprintf('%d th iter has finished.\r', i);
    end
end

if (param.gpu == 1)
    V_GPU = gpuArray(V);
    R_GPU = gpuArray(R);
    B = ones(size(V,1),size(R,2)).*-1;
    B_GPU_constant = gpuArray(B);
    for iter = 0:1000
        Z = V_GPU * R_GPU;
        B_GPU = B_GPU_constant;
        B_GPU(Z>=0) = 1;
        [UB, ~, UA] = svd(B_GPU' * V_GPU);
        R_GPU = UA * UB';
        fprintf('%d th iter has finished.\r', iter);
    end 
    B = gather(B_GPU);
    R = gather(R_GPU);
else
    for iter = 0:1000
        Z = V * R;
        B = ones(size(Z,1),size(Z,2)).*-1;
        B(Z>=0) = 1;
        [UB, ~, UA] = svd(B' * V);
        R = UA * UB';
        fprintf('%d th iter has finished.\r',iter);
    end
end

param.B = B;
param.r = R;

end