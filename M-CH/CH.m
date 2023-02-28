function [Btrain,Btest] = CH(Xtrain,Xtest,KB,bit)
% ===================================================
% input
% Xtest: test data
% Xdata: data from the dataset
% bit: the number of the bits
% method: the name of the method
% para: the parameter of the method
% numTrain: the number of the training data

% output
% Btest: binary codes of the test data
% Bdata: binary codes of the data from the dataset
% Tdata: the training time
% ===================================================
addpath('./C-Utils/');
for i = 1 : 30
    if i == 1
        rrl = randperm(size(Xtrain, 1));
        centers = Xtrain(rrl(1:KB), :);
    else
        for j = 1 : KB
            l = find(assignments == j);
            centers(j, :) = mean(Xtrain(l, :), 1);
        end
    end
    DD = zeros(size(Xtrain, 1), KB);
    for j = 1 : KB
        D = bsxfun(@minus, Xtrain, centers(j, :));
        D = sum(D .^ 2, 2);
        DD(:, j) = D;
    end
    [~, assignments] = min(DD, [], 2);
end
XX = [Xtrain; Xtest];
display('clustering finished');

% ===================================================
bitRotation = zeros( KB, size(XX,2), bit/KB );
bitMeans = zeros( KB, size(XX,2) );
for i = 1 : KB
    tic;
    RX =  Xtrain(find(assignments==i),:);
    bitMeans( i, : ) = mean( RX, 1 );
    RX = bsxfun(@minus, RX, bitMeans( i, : ));
    [pc,~] = eigs(cov(double(RX)),bit/KB);
    RX = RX * pc;
    [Y, R] = ITQ(RX,50);
    toc;
    bitRotation( i, :, : ) = pc * R;
end
display('ITQ finished');

% ===================================================
Tdata = toc;
nTraining = size(Xtrain, 1);
Btrain = zeros( nTraining, bit );
Btest = zeros( size(XX,1)-nTraining, bit );

tic;
for i = 1 : KB
    RR = reshape(bitRotation( i, :, : ),[size(XX,2), bit/KB]);
    RX = bsxfun(@minus,XX( 1:nTraining, : ),bitMeans(i,:));
    RX = RX * RR;
    Btrain( :, (i-1)*(bit/KB)+1:i*(bit/KB))= (RX >= 0);
end
toc;

tic;
for i = 1 : KB
    RR = reshape(bitRotation( i, :, : ),[size(XX,2), bit/KB]);
    RX = bsxfun(@minus,XX( nTraining+1:end, : ),bitMeans(i,:));
    RX = RX * RR;
    Btest( :, (i-1)*(bit/KB)+1:i*(bit/KB))= (RX >= 0);
end
toc;
display('encoding finished');
% ===================================================

Btrain = compactbit(Btrain);
Btest = compactbit(Btest);
clear XX;

end