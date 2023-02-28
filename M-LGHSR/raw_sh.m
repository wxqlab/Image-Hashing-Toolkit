%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Y, W, F, Z, sigma] = raw_sh(X, Anchor, r, s, sigma)
%
% One-Layer Anchor Graph Hashing Training 
% Written by Wei Liu (wliu@ee.columbia.edu)
% X = nXdim input data 
% Anchor = mXdim anchor points (m<<n)
% r = number of hash bits
% s = number of nearest anchors
% sigma: Gaussian RBF kernel width parameter; if no input (sigma=0) this function will
%        self-estimate and return a value. 
% Y = nXr binary codes (Y_ij in {1,0})
% W = mXr projection matrix in spectral space
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n,dim] = size(X);
m = size(Anchor,1);


%% get Z
Z = zeros(n,m);
Dis = sqdist(X',Anchor');
clear X;
clear Anchor;

val = zeros(n,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = min(Dis,[],2);
    tep = (pos(:,i)-1)*n+[1:n]';
    Dis(tep) = 1e60; 
end
clear Dis;
clear tep;

if sigma == 0
   sigma = mean(val(:,s).^0.5);
end
val = exp(-val/(1/1*sigma^2));
val = repmat(sum(val,2).^-1,1,s).*val; %% normalize
tep = (pos-1)*n+repmat([1:n]',1,s);
Z([tep]) = [val];
Z = sparse(Z);
clear tep;
clear val;
clear pos;

%% compute eigensystem 
Z = Z';
D_ = diag((full(sum(Z,2))).^(-1/2));
Z_ = sparse(D_*Z);

% [U,S,V] = svds(Z_,100);
[U,S,V] = svds(Z_,200);

eigenvalue = diag(S)';
ind = find(eigenvalue>0 & eigenvalue<1-1e-3);
eigenvalue = eigenvalue(ind);

F = V(:,2:r+1);
config.step = 20;
[binary_coding, Q] = binaryValueCoding(F, config);
Y = F*Q>0;
W = ((F*Q)'*Z'*diag((full(sum(Z,2))).^(-1)))';
%Y= F>0;
%W = ((F)'*Z'*diag((full(sum(Z,2))).^(-1)))';










