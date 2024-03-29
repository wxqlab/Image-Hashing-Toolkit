function [Btrain,Btest] = trainSH(Xtrain,Xtest,param)
% =========================================================================
% SH: Spectral Hashing
% Spectral hashing -- NIPS 2008
% =========================================================================
%% parameter settings
addpath('./C-Utils/');
X = Xtrain;
nbits = param.bit;
[Nsamples,Ndim] = size(X);

%% train SH model
% algo:

% 1) PCA
npca = min(nbits, Ndim);
[pc, l] = eigs(cov(X), npca);
X = X * pc; % no need to remove the mean


% 2) fit uniform distribution
mn = prctile(X, 5);  mn = min(X)-eps;
mx = prctile(X, 95);  mx = max(X)+eps;


% 3) enumerate eigenfunctions
R=(mx-mn);
maxMode=ceil((nbits+1)*R/max(R));

nModes=sum(maxMode)-length(maxMode)+1;
modes = ones([nModes npca]);
m = 1;
for i=1:npca
    modes(m+1:m+maxMode(i)-1,i) = 2:maxMode(i);
    m = m+maxMode(i)-1;
end
modes = modes - 1;
omega0 = pi./R;
omegas = modes.*repmat(omega0, [nModes 1]);
eigVal = -sum(omegas.^2,2);
[yy,ii]= sort(-eigVal);
modes=modes(ii(2:nbits+1),:);


% 4) store paramaters
SHparam.pc = pc;
SHparam.mn = mn;
SHparam.mx = mx;
SHparam.mx = mx;
SHparam.modes = modes;

SHparam.bits = nbits;

% compress training and test set
[Btrain,Utrain] = compressSH(Xtrain, SHparam);
[Btest,Utest] = compressSH(Xtest, SHparam);

end 