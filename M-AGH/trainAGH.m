function [Btrain,Btest] = trainAGH(Xtrain,Xtest,param)
% =========================================================================
% AGH: Anchor Graph Hashing
% Hashing with graphs -- ICML 2011
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
param.s = 5;
param.anchor = 500;
param.AGH_method = 'One';

%% train AGH model
% get anchor
anchor_nm = ['anchor_' num2str(param.anchor)];
eval(['[~,' anchor_nm '] = litekmeans(Xtrain, param.anchor, ''MaxIter'', 10);']);
eval(['anchor_set.' anchor_nm '= ' anchor_nm, ';']);
eval(['anchor = anchor_set.' anchor_nm ';']);

% get hash code
switch(param.AGH_method)
    
    case 'One'
        % One-Layer AGH
        [Y, W, sigma] = OneLayerAGH_Train(Xtrain, anchor, param.bit, param.s, 0);
        tY = OneLayerAGH_Test(Xtest, anchor, W, param.s, sigma);
        Btrain = compactbit(Y);
        Btest = compactbit(tY);
        
    case 'Two'
        % Two-Layer AGH
        [Y, W, thres, sigma] = TwoLayerAGH_Train(Xtrain, anchor, param.bit, param.s, 0);
        tY = TwoLayerAGH_Test(Xtest, anchor, W, thres, param.s, sigma);
        Btrain = compactbit(Y);
        Btest = compactbit(tY);
        
    otherwise
        fprintf('not recognized method %s\n', method);
end

end

