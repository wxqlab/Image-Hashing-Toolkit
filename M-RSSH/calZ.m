function [ Z ] = calZ( C )
%  max tr(C*Z')
[n,b] = size(C);
tmpcjc = C'*C - 1/n*C'*ones(n,1)*ones(n,1)'*C;
[V,D] = eig(tmpcjc);
[D,index] = sort(diag(D),'descend');
D = diag(D);
V = V(:,index);
for k=1:b
    if D(k,k)<1e-5
        k = k-1;
        break;
    end
end
D = D(1:k,1:k);
D = D.^0.5;
% U = J*C*V(:,1:k)/D;
U = (C*V(:,1:k)-1/n*ones(n,1)*(ones(n,1)'*C*V(:,1:k)))/D;
b_ = b-k;
if(b_>0)
    UY = rand(n,b_);
    UY = UY - repmat(mean(UY),n,1);
    U = [U,UY];
    U = Schmidt(U);
end
Z = sqrt(n)*U*V';

end

