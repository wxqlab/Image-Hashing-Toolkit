function [B1,B2] = CBE(Xtrain,Xtest,param)

d = size(Xtrain, 2);
rand_bit = randperm(d);
train_size = min(size(Xtrain,1), 5000);

switch(param.method)
    
    case 'CBE-rand'
        model = circulant_rand(d);
        B1 = CBE_prediction(model, Xtrain);
        B2 = CBE_prediction(model, Xtest);
        if (param.bit < d)
            B1 = B1 (:, rand_bit(1:param.bit));
            B2 = B2 (:, rand_bit(1:param.bit));
        end
        
    case 'CBE-opt'
        if (~isfield(param, 'lambda'))
            param.lambda = 1;
        end
        if (~isfield(param, 'verbose'))
            param.verbose = 0;
        end
        [~, model] = circulant_learning(double(Xtrain(1:train_size, :)), param);
        B1 = CBE_prediction(model, Xtrain);
        B2 = CBE_prediction(model, Xtest);
        if (param.bit < d)
            B1 = B1 (:, 1:param.bit);
            B2 = B2 (:, 1:param.bit);
        end
end

end