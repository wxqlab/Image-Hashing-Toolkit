function [Btrain,Btest] = trainCH(Xtrain,Xtest,param)
% =========================================================================
% CH: Concatenation Hashing
% Concatenation hashing: A relative position preserving method for learning
% binary codes -- Pattern Recognition 2020
% =========================================================================
bit = param.bit;
if (bit == 8)
    KB = 2;
else if (bit == 16)
        KB = 2;
    else if (bit == 32)
            KB = 2;
        else if (bit == 64)
                KB = 4;
            else if (bit == 96)
                    KB = 4;
                else if (bit == 128)
                        KB = 4;
                    end
                end
            end
        end
    end
end

% zero mean
m = mean(Xtrain);
Xtrain = bsxfun(@minus, Xtrain, m);
Xtest = bsxfun(@minus, Xtest, m);

% get the hash codes
[Btrain,Btest] = CH(Xtrain,Xtest,KB,bit);

end