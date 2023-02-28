function [Btrain,Btest] = trainIMH(Xtrain,Xtest,param)
% =========================================================================
% IMH: Inductive Manifold Hashing
% Hashing on nonlinear manifolds -- TIP 2015
% Inductive hashing on manifolds -- CVPR 2013
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.anchor = 400;
param.maxbits = param.bit;
param.IMH_method = 'IMH-LE';

switch(param.IMH_method)
    case 'IMH-tSNE'
        param.s = 5;
        param.sigma = 0;
    case 'IMH-LE'
        param.s = 5;
        param.sigma = 0;
        param.k = 20; % knn graph
        param.bTrueKNN  = 0; % if 0, construct symmetric graph for S
end

%% train IMH model
% get anchor
anchor_nm = ['anchor_' num2str(param.anchor)];
eval(['[~,' anchor_nm '] = litekmeans(Xtrain, param.anchor, ''MaxIter'', 10);']);
eval(['anchor_set.' anchor_nm '= ' anchor_nm, ';']);
eval(['anchor = anchor_set.' anchor_nm ';'])

% get hash code
switch(param.IMH_method)
    
    case 'IMH-LE'
        % IMH-LE
        [Embedding,Z_RS,sigma] = InducH(anchor, Xtrain, param);
        EmbeddingX = Z_RS*Embedding;
        Btrain = EmbeddingX > 0;
        Btrain = compactbit(Btrain);
        [tZ] = get_Z(Xtest, anchor, param.s, sigma);
        tEmbedding = tZ*Embedding;
        Btest = tEmbedding > 0;
        Btest = compactbit(Btest);
        
    case 'IMH-tSNE'
        % IMH-tSNE
        [Embedding] = tSNEH(anchor, param);
        [Z,~, sigma] = get_Z(Xtrain, anchor, param.s, param.sigma);
        EmbeddingX = Z*Embedding;
        Btrain = EmbeddingX > 0;
        Btrain = compactbit(Btrain);
        [tZ] = get_Z(Xtest, anchor,  param.s, sigma);
        tEmbedding = tZ*Embedding;
        Btest = tEmbedding > 0;
        Btest = compactbit(Btest);
        
    otherwise
        fprintf('not recognized method %s\n', method);
end

end
