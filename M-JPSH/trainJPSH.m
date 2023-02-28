function [Btrain,Btest] = trainJPSH(Xtrain,Xtest,param)

addpath('./C-Utils/');

%% parameter settings
switch(param.dataset)
    case 'MNIST'
        param.Kanchor = 7;
        param.Nanchor = 800;
        param.k = 5;
        param.lam1 = 1e1;
        param.lam2 = 1e0;
        param.lam3 = 1e0;
        param.Maxitr = 10;
        param.biasflag = 1;
    case 'FLICKR25K'
        param.Kanchor = 5;
        param.Nanchor = 500;
        param.k = 7;
        param.lam1 = 1e5;
        param.lam2 = 1e1;
        param.lam3 = 1e1;
        param.Maxitr = 10;
        param.biasflag = 1;
    case 'CIFAR-10'
        param.Kanchor = 7;
        param.Nanchor = 800;
        param.k = 5;
        param.lam1 = 1e1;
        param.lam2 = 1e0;
        param.lam3 = 1e0;
        param.Maxitr = 4;
        param.biasflag = 1;
    case 'NUS-WIDE'
        param.Kanchor = 5;
        param.Nanchor = 1000;
        param.k = 7;
        param.lam1 = 1e5;
        param.lam2 = 1e1;
        param.lam3 = 1e1;
        param.Maxitr = 5;
        param.biasflag = 1;
    otherwise
        fprintf('not recognized dataset %s\n', param.dataset);
end

if param.biasflag == 1
    Xtrain = [Xtrain, ones(size(Xtrain,1),1)];
    Xtest = [Xtest, ones(size(Xtest,1),1)];
end

%% train CPH model
% get anchor
way = 'random';
switch(way)
    case 'random'
        anchor = Xtrain(randperm(size(Xtrain,1),param.Nanchor),:);
    case 'k-means'
        anchor_nm = ['anchor_' num2str(param.Nanchor)];
        eval(['[~,' anchor_nm '] = litekmeans(Xtrain, param.Nanchor, ''MaxIter'', 10);']);
        eval(['anchor_set.' anchor_nm '= ' anchor_nm, ';']);
        eval(['anchor = anchor_set.' anchor_nm ';'])
    otherwise
        fprintf('not recognized way %s\n', way);
end
[~,Z, ~] = get_Z(Xtrain, anchor, param.Kanchor ,0 );

% get affinity
param.NeighborMode = 'KNN';
param.WeightMode = 'HeatKernel';
S = constructW(anchor,param);

% training model
[AP,WU,Fval] = JPSH(Xtrain',anchor',Z,S,param.bit,param.lam1,param.lam2,param.lam3,param.Maxitr,param.biasflag);
plot(Fval,'*-')

% compact hash code
Xtrp = Xtrain*AP';
dis = pdist2(Xtrain,anchor);
[~,idx] = min(dis,[],2);
for k = 1:size(Xtrain,1)
    H(k,:) = Xtrp(k,:) + anchor(idx(k),:)*(WU{idx(k)})';
end
clear dis idx

Xtep = Xtest*AP';
dis = pdist2(Xtest,anchor);
[~,idx] = min(dis,[],2);
for k = 1:size(Xtest,1)
    tH(k,:) = Xtep(k,:) + anchor(idx(k),:)*(WU{idx(k)})';
end
clear dis idx

H = H > 0;
tH = tH > 0;
Btrain = compactbit(H);
Btest = compactbit(tH);

end