function [U,V] = MF(X,r)
    [d,n] = size(X);
    U = rand(n,r);
    V = rand(r,n);
    for i=1:100
        U = V'/(V*V');
        V = (U'*X'*X*U)\(U'*X'*X);
    end
end

