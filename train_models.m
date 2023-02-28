function [Ytrain,Ytest,Btrain,Btest,T] = train_models(param)

%% prepare dataset
addpath('./A-Datasets/');
load(param.dataset);

switch(param.dataset)
    case 'MNIST'
        Xtrain = double(traindata);
        Ytrain = double(traingnd);
        Xtest = double(testdata);
        Ytest = double(testgnd);
    case 'CIFAR-10'
        Xtrain = double(traindata);
        Ytrain = double(traingnd);
        Xtest = double(testdata);
        Ytest = double(testgnd);
    case 'FLICKR25K'
        Xtrain = double(traindata);
        Ytrain = double(traingnd);
        Xtest = double(testdata);
        Ytest = double(testgnd);
    case 'NUS-WIDE'
        Xtrain = double(traindata);
        Ytrain = double(traingnd);
        Xtest = double(testdata);
        Ytest = double(testgnd);
    case 'cifar_db_test_relu7'
        Xtrain = double(data_set);
        Ytrain = double(dataset_L);
        Xtest = double(test_data);
        Ytest = double(test_L);
    case 'flickr_db_test_relu7'
        Xtrain = double(data_set);
        Ytrain = double(dataset_L);
        Xtest = double(test_data);
        Ytest = double(test_L);
    case 'nus_db_test_relu7'
        Xtrain = double(data_set);
        Ytrain = double(dataset_L);
        Xtest = double(test_data);
        Ytest = double(test_L);
end

%% perform training process
fprintf('......coding by %s to %d bits on %s dataset......\n',param.method,param.bit,param.dataset);
switch(param.method)
    case 'JPSH'
        addpath('./M-JPSH/');
        t1 = clock;
        [Btrain,Btest] = trainJPSH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'CH'
        addpath('./M-CH/');
        t1 = clock;
        [Btrain,Btest] = trainCH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'RSSH'
        addpath('./M-RSSH/');
        t1 = clock;
        [Btrain,Btest] = trainRSSH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'JSH'
        addpath('./M-JSH/');
        t1 = clock;
        [Btrain,Btest] = trainJSH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'LGHSR'
        addpath('./M-LGHSR/');
        t1 = clock;
        [Btrain,Btest] = trainLGHSR(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'ADLLH'
        addpath('./M-ADLLH/');
        t1 = clock;
        [Btrain,Btest,Ytrain] = trainADLLH(Xtrain,Xtest,Ytrain,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'OCH'
        addpath('./M-OCH/');
        t1 = clock;
        [Btrain,Btest] = trainOCH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'OEH'
        addpath('./M-OEH/');
        t1 = clock;
        [Btrain,Btest] = trainOEH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'SGH'
        addpath('./M-SGH/');
        t1 = clock;
        [Btrain,Btest] = trainSGH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'SP'
        addpath('./M-SP/');
        t1 = clock;
        [Btrain,Btest] = trainSP(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'IMH'
        addpath('./M-IMH/');
        t1 = clock;
        [Btrain,Btest] = trainIMH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'ITQ'
        addpath('./M-ITQ/');
        t1 = clock;
        [Btrain,Btest] = trainITQ(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'AGH'
        addpath('./M-AGH/');
        t1 = clock;
        [Btrain,Btest] = trainAGH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'SH'
        addpath('./M-SH/');
        t1 = clock;
        [Btrain,Btest] = trainSH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'LSH'
        addpath('./M-LSH/');
        t1 = clock;
        [Btrain,Btest] = trainLSH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'KNNH'
        addpath('./M-KNNH/');
        t1 = clock;
        [Btrain,Btest] = trainKNNH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'DSH'
        addpath('./M-DSH/');
        t1 = clock;
        [Btrain,Btest] = trainDSH(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    case 'CBE'
        addpath('./M-CBE/');
        t1 = clock;
        [Btrain,Btest] = trainCBE(Xtrain,Xtest,param);
        t2 = clock;
        T = etime(t2,t1);
    otherwise
        fprintf('not recognized method %s\n', method);
end
end