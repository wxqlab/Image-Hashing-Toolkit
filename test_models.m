function test_models(param,save_path)

addpath('./B-Metrics/');

%% get performance
for i = 1:length(param.methods)
    param.method = param.methods{i};
    for j = 1:length(param.datasets)
        param.dataset = param.datasets{j};
        for m = 1:length(param.bits)
            param.bit = param.bits(m);
            for n = 1:param.runtimes
                % train the model
                [Ytrain,Ytest,Btrain,Btest,T] = train_models(param);
                Time{m,n} = T;
                % test the model
                [mAP{m,n},Rec{m,n},Pre{m,n},Precision{m,n},Recall{m,n},Fmeasure{m,n},Precision100{m,n}]...
                    = test_traditional_mAP_Pre_Rec_Fmeasure(Ytrain,Ytest,Btrain,Btest,param);
            end
        end
        save([save_path,param.method,'_',param.dataset,'.mat'],'mAP','Rec','Pre','Precision','Recall','Precision100','Fmeasure','Time');
    end
end

end