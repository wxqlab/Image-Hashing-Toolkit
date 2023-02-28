function B = testKNNH(X, param, test_sample)

if (isfield(param, 'pcaW') == 1)
    V = X*param.pcaW;
else
    V = X;
end

if test_sample == 1
    U = V*param.r;
else
    U = param.B;
end
B = (U>0);
