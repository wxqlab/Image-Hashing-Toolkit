function visualize_results(param,save_path)

addpath(save_path)
addpath('./D-Shows/')
addpath('./A-Datasets/')

%% load retrieval results
for i = 1:length(param.datasets) 
    if strcmp(param.datasets{i},'MNIST')
        load('MNIST.mat');
        Len = length(testgnd);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_MNIST.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end
    if strcmp(param.datasets{i},'CIFAR-10')
        load('CIFAR-10.mat');
        Len = length(testgnd);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_CIFAR-10.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end
    if strcmp(param.datasets{i},'FLICKR25K')
        load('FLICKR25K.mat');
        Len = length(testgnd);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_FLICKR25K.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end
    if strcmp(param.datasets{i},'NUS-WIDE')
        load('NUS-WIDE.mat');
        Len = length(testgnd);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_NUS-WIDE.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end
    if strcmp(param.datasets{i},'cifar_db_test_relu7')
        load('cifar_db_test_relu7.mat');
        Len = length(test_L);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_cifar_db_test_relu7.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end
    if strcmp(param.datasets{i},'flickr_db_test_relu7')
        load('flickr_db_test_relu7.mat');
        Len = length(test_L);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_flickr_db_test_relu7.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end
    if strcmp(param.datasets{i},'nus_db_test_relu7')
        load('nus_db_test_relu7.mat');
        Len = length(test_L);
        for j = 1:length(param.methods)
            filename = [param.methods{j},'_nus_db_test_relu7.mat',];
            load(filename);
            MAP{j} = mAP;
            PRE{j} = Pre;
            REC{j} = Rec;
            recall{j} = Recall;
            precision{j} = Precision;
            fmeasure{j} = Fmeasure;
            precision100{j} = Precision100;
        end
    end  
    calculate_results(MAP,REC,PRE,precision,recall,fmeasure,precision100,Len,param,save_path);
end

end