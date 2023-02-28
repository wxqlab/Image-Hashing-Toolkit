function [W,B] = RSSH(train_data,B,G,lambda,beta,eta,b,epchos,U,V)
% ||qS-AG'||+beta||A-B||+lambda||G-B||
X_kernel = train_data;
[n,dim] = size(X_kernel);

mx = 0;
for i=1:n
    mx = max(mx,(U(i,:)*V(:,i))^2);
end
[n,r] = size(U);
len = r*(r-1)/2;
U_ = zeros(n,len);
V_ = zeros(len,n);
count = 1;
for i=1:r-1
    for j=i+1:r
        U_(:,count) = U(:,i).*U(:,j);
        V_(count,:) = V(i,:).*V(j,:);
        count = count+1;
    end
end
U = U.^2;
V = V.^2;

% S = 1/mx*(U*V+2*U_*V_+V'*U'+2*V_'*U_')-ones(n,1)*ones(1,n);
%%
for i=1:epchos
%% «ÛA
% C = b*S*G+beta*B;
SG = 1/mx*(U*(V*G)+2*U_*(V_*G)+V'*(U'*G)+2*V_'*(U_'*G))-ones(n,1)*(ones(1,n)*G);
C = b*SG + beta*B;
A = calZ(C);
%% «ÛG
SA = 1/mx*(U*(V*A)+2*U_*(V_*A)+V'*(U'*A)+2*V_'*(U_'*A))-ones(n,1)*(ones(1,n)*A);
G = (b*SA+lambda*B)/(n+lambda);
%% «ÛB
B = sgn(beta*A+lambda*G);
end
%%
W = (X_kernel'*X_kernel+eta*eye(dim))\X_kernel'*B;
end