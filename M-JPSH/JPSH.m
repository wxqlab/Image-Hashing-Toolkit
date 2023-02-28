function [AP,WU,Fval] = JPSH(Xtrain,Anchor,Z,S,L,lam1,lam2,lam3,Maxitr,biasflag)

%% initialzation
X = Xtrain;
[d,~] = size(X);
[~,m] = size(Z);
idx = 1:m*d;
ind = d * ones(1,m);

Dz = diag(sum(Z,2));
XZ = X*Z;
XX = X*Dz*X';
Y = zeros(m*d,m);
for i = 1:m
    Y(1+d*(i-1):i*d,i) = Anchor(:,i);
end
Y = sparse(Y);
YY = Y*Y';

A = speye(L);
W = speye(L);
G = speye(d);
D = speye(m*d);
randn('seed',2);
B = sign(randn(L,m));

%% start iteration
for ite = 1:Maxitr
    
    % ======================================================
    % update P = (lam1*G+X*X')\XZ*B'*A
    p1 = lam1.*G + XX;
    p2 = XZ*B'*A;
    P = p1\p2;
    clear p1 p2
    % ======================================================
    % update U = (lam2*K+lam3*kron(E,I))\Y*B'*W
    % D = lam2.*K + lam3.*EI;
    u1 = D\Y;
    u2 = B'*W;
    u3 = (speye(m) + Y'*u1)\u2;
    U = u1*u3;
    clear u1 u2 u3    
    % ======================================================
    % update K
    if biasflag == 0
        tmp1 = sqrt(sum(U.*U,2));
        tmp2 = mat2cell(tmp1,ind,1);
        Ul21 = cellfun(@sum,tmp2);
        SumUl212 = sum(Ul21.^2);
        
        nUl21 = repmat(Ul21',d,1);
        K = sparse(idx,idx,nUl21(:)./(tmp1+0.00001));
        clear tmp1 tmp2 Ul21 nUl21
    else
        tmp1 = sqrt(sum(U.*U,2));
        tmp2 = mat2cell(tmp1,ind,1);
        Ul21 = cellfun(@sum,tmp2);
        SumUl212 = sum(Ul21.^2);
        
        nUl21 = repmat(Ul21',d,1);
        nUl21(end,:) = 0;
        K = sparse(idx,idx,nUl21(:)./(tmp1+0.00001));
        clear tmp1 tmp2 Ul21 nUl21
    end
    % ======================================================
    % update EI
    dis = distLf(U,U,ind,L);
    tmp1 = dis.*S;
    SumUlf = sum(tmp1(:));
    
    tmp2 = (0.5./(dis+0.00001)).*S;
    td1 = diag(sum(tmp2,1));
    td2 = diag(sum(tmp2,2));
    E = td1 + td2 - 2*tmp2;
    E = (E + E')/2 + eye(m)*0.001;
    EI = kron(sparse(E),speye(d));
    clear dis tmp1 tmp2 td1 td2 E
    
    D = lam2.*K + lam3.*EI;    
    % ======================================================
    % obtain objective function value Fval
    Fval(ite) = -trace(2.*A*P'*XZ*B')+trace(lam1.*P'*G*P)+trace(P'*XX*P)-trace(2.*W*U'*Y*B')+trace(U'*YY*U)+lam2*SumUl212+lam3*SumUlf;   
    % ======================================================
    % update A: svd(P'*XZ*B')
    [tu1,~,tv1] = svd(P'*XZ*B');
    A = tv1 * tu1';
    clear tu1 tv1
    % ======================================================
    % update W: svd(U'*Y*B')
    [tu2,~,tv2] = svd(U'*Y*B');
    W = tv2 * tu2';
    clear tu2 tv2
    % ======================================================
    % update G = 1/2*||p^i||_2
    g1 = sqrt(sum(P.*P,2)+0.00001);
    g2 = 0.5./g1;
    G = diag(g2);
    clear g1 g2
    % ======================================================
    % update B = sign(A*P'*XZ+W*U'*Y)
    B = sign(A*P'*XZ+W*U'*Y);
end

%% obtain coding matrix F
AP = A*P';
for i = 1:m
    WU{i} = W*(U(1+d*(i-1):i*d,:))';
end
end