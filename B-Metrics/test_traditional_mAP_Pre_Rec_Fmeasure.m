function [mAP,Rec,Pre,Precision,Recall,Fmeasure,Precision100] = test_traditional_mAP_Pre_Rec_Fmeasure(Ytrain,Ytest,Btrain,Btest,param)

max_hamm = param.bit;
addpath('./B-Metrics/');
param.pos = [1:30:91 100:100:size(Ytest,1)];

%% compute mAP, Pre, Rec and Fmeasure
if size(Ytrain,2) == 1    
    % mAP
    Wture = compute_S(Ytrain,Ytest) ;
    Dhamm = hammingDist(Btest, Btrain);
    [mAP,Precision100] = callMap(Wture', Dhamm);
    % Fmeasure
    hammRadius = 2;
    hammTrainTest = (Dhamm' <= hammRadius+0.00001);
    cateTrainTest = bsxfun(@eq, Ytrain, Ytest');
    [tmpPre, tmpRec] = evaluate_macro(cateTrainTest, hammTrainTest);
    Fmeasure = F1_measure(tmpPre, tmpRec);   
    % Rec vs Pre curve
    [Rec, Pre, ~] = recall_precision(Wture', Dhamm, max_hamm);   
    % Precision and Recall
    [Recall, Precision]= recall_precision5(Wture', Dhamm, param.pos);      
else  
    % mAP
    topk = size(Ytrain,1);
    [topkmap,pre100] = calculateTopMap(Btrain,Btest,Ytrain,Ytest,topk);
    mAP  = topkmap;
    Precision100 = pre100;
    % Fmeasure
    hammRadius = 2;
    hammTrainTest = hammingDist(Btest, Btrain)';
    Ret = (hammTrainTest <= hammRadius+0.00001);
    cateTrainTest = double(Ytrain)*double(Ytest') > 0;
    [tmpPre, tmpRec] = evaluate_macro(cateTrainTest, Ret);
    Fmeasure = F1_measure(tmpPre, tmpRec);
    % Rec vs Pre curve
    [Rec, Pre, ~] = recall_precision(cateTrainTest', hammTrainTest', max_hamm);
    % Precision and Recall
    [Recall, Precision]= recall_precision5(cateTrainTest', hammTrainTest', param.pos);
end

end