function [S] = getSimilarMatrix(X,K)
tic
[D,N] = size(X);
if K==0
    K = 10;
end
fprintf(1,'LLE running on %d points in %d dimensions\n',N,D);
% STEP1: COMPUTE PAIRWISE DISTANCES & FIND NEIGHBORS 
fprintf(1,'-->Finding %d nearest neighbours.\n',K);
X2 = sum(X.^2,1);
distance = repmat(X2,N,1)+repmat(X2',1,N)-2*X'*X;
[sorted,index] = sort(distance);
clear distance;
neighborhood = index(2:(1+K),:);
% STEP2: SOLVE FOR RECONSTRUCTION WEIGHTS
fprintf(1,'-->Solving for reconstruction weights.\n');

if(K>D) 
  fprintf(1,'   [note: K>D; regularization will be used]\n'); 
  tol=1e-3; % regularlizer in case constrained fits are ill conditioned
else
  tol=0;
end
W = zeros(K,N);
for ii=1:N
   z = X(:,neighborhood(:,ii))-repmat(X(:,ii),1,K); % shift ith pt to origin
   C = z'*z;                                        % local covariance
   C = C + eye(K,K)*tol*trace(C);                   % regularlization (K>D)
   W(:,ii) = C\ones(K,1);                           % solve Cw=1
   W(:,ii) = W(:,ii)/sum(W(:,ii));                  % enforce sum(w)=1
end;
neigN = numel(neighborhood);
reNeighborhood = reshape(neighborhood,neigN,1);
clear neighborhood;
xindex = 1:N;
xindex = repmat(xindex,K,1);
xindex = reshape(xindex,K*N,1);
reW = reshape(W,K*N,1);
S = sparse(xindex,reNeighborhood,reW,N,N,K*N);
toc
