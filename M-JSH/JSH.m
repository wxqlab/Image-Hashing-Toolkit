function [F, B] = JSH(X,Z,s,L,alpha,maxItr)
%function
%    min ||b_j-AP'x_i||Zij+alpha*||P||21; 
%input
%     X:      d*n training data. Each column is a sample.
%     Z:      n*m anchor graph.
%     s:      desired dimensions. In our paper, we set s=L.
%     L:      length of binary code.
%     alpha:  L21-norm parameter.
%     maxItr: number of iteration.
%output
%     F:      hash function.
%     B:      binary code of anchor data.

%% Initialization
    [d,n]=size(X);
    [n,m]=size(Z);
    randn('seed',2);
    B=sign(randn(L,m));
    A = eye(L,s);
    P = zeros(d,s);
    G = eye(d,d);
    D = diag(sum(Z,2));
    
    XZ=X*Z;
    XDX=X*D*X';
    
%% Start iteration
for ite=1:maxItr
    % obtain P
    P=(alpha*G+XDX)\XZ*B'*A;
    
    % obtain A
    PXZ=P'*XZ;
    [U,~,V]=svd(PXZ*B');
    A=V*U'; 
    
    % obtain B 
    Q = A*PXZ;
    B = sign(Q);
    
    % obtain objective function value
    testconvergence(ite)=-trace(2.*A*P'*X*Z*B')+trace(P'*X*D*X'*P)+trace(alpha*P'*G*P);
    
    % update G 
    Xi1 = sqrt(sum(P.*P,2)+eps);   
    d1 = 0.5./Xi1;  
    G = diag(d1);
    
end

    %obtain F
    F=A*P';
    
end