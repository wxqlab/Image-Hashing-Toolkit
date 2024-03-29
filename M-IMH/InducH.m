function [EmbeddingS, W_RS_nmlz, sigma] = InducH(S, R, param)
% function for IMH-LEH in the paper

r = param.bit;

%% constuct graph on  S
[~,W_SS] = get_Z(S, S, param.k, param.sigma); 
if isfield(param,'bTrueKNN') && param.bTrueKNN  
else
    W_SS = max(W_SS,W_SS');
end

D_SS = diag(full(sum(W_SS,2))); 
M = D_SS - W_SS;

%% constuct graph on  SR
[W_RS_nmlz, W_RS,sigma] = get_Z(R, S, param.s, param.sigma);

D_SR = diag(sum(W_RS,1));
T = D_SR - W_RS_nmlz'*W_RS;

%% compute eigensystem
[V, eigenvalue] = eig(M + 2*T);


[eigenvalue,order] = sort(diag(eigenvalue));
V = V(:,order);
clear order;
ind = eigenvalue> 1e-3;
V = V(:,ind);
EmbeddingS = V(:,1:r);


end
