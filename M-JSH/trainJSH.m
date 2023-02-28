function [Btrain,Btest] = trainJSH(Xtrain,Xtest,param)
% =========================================================================
% JSH: Jointly Sparse Hashing
% Jointly Sparse Hashing for Image Retrieval -- TIP 2018
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
switch(param.dataset)
    case 'MNIST'
        param.knum = 5;
        param.alpha = 10;
        param.maxIte = 10;
        param.anchor = 500;
    case 'FLICKR25K'
        param.knum = 10;
        param.alpha = 10;
        param.maxIte = 10;
        param.anchor = 500;
    case 'CIFAR-10'
        param.knum = 5;
        param.alpha = 10;
        param.maxIte = 5;
        param.anchor = 500;
    case 'NUS-WIDE'
        param.knum = 10;
        param.alpha = 10;
        param.maxIte = 10;
        param.anchor = 500;
    otherwise
        param.knum = 5;
        param.alpha = 10;
        param.maxIte = 10;
        param.anchor = 500;
end

Xtrain = [Xtrain, ones(size(Xtrain,1),1)];
Xtest = [Xtest, ones(size(Xtest,1),1)];

%% train JSH model
% get anchor
anchor_nm = ['anchor_' num2str(param.anchor)];
eval(['[~,' anchor_nm '] = litekmeans(Xtrain, param.anchor, ''MaxIter'', 10);']);
eval(['anchor_set.' anchor_nm '= ' anchor_nm, ';']);
eval(['anchor = anchor_set.' anchor_nm ';'])
[~,Z, ~] = get_Z(Xtrain, anchor, param.knum ,0 );

% get hash code
[F,~] = JSH(Xtrain',Z,param.bit,param.bit,param.alpha,param.maxIte);
H = Xtrain*F' > 0;
tH = Xtest*F' > 0;
Btrain = compactbit(H);
Btest = compactbit(tH);

end