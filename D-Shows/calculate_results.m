function calculate_results(mAP,Rec,Pre,Precision,Recall,Fmeasure,Precision100,Len,param,save_path)

%% set the lines
addpath('./C-Utils/');

line_width = 1.5;
marker_size = 5;
linewidth = 1.4;
xy_font_size = 14;
title_font_size = 12;
legend_font_size = 10;

param.pos = [1:30:91 100:100:Len];

%% get average mAP
for i = 1:length(param.datasets)
    param.dataset = param.datasets{i};
    for j = 1:length(param.methods)
        param.method = param.methods{j};
        tmp = cell2mat(mAP{j});
        mean_bits = mean(tmp,2);
        std_bits = std(tmp');
        results = [mean_bits,std_bits'];
        char_name = {'bits','map_mean','map_std'};
        tmp = [param.bits',results];
        [p,q] = size(tmp);
        data = mat2cell(tmp, ones(p,1), ones(q,1));
        allresults = [char_name; data];
        xlswrite([save_path, param.method,'_',param.dataset,'_mAP','.xlsx'], allresults);
        clear tmp results allresults
    end
end

%% get average Fmeasure
for i = 1:length(param.datasets)
    param.dataset = param.datasets{i};
    for j = 1:length(param.methods)
        param.method = param.methods{j};
        tmp = cell2mat(Fmeasure{j});
        mean_Fmea = mean(tmp,2);
        std_Fmea = std(tmp');
        results = [mean_Fmea,std_Fmea'];
        char_name = {'bits','Fmeasure_mean','Fmeasure_std'};
        tmp = [param.bits',results];
        [p,q] = size(tmp);
        data = mat2cell(tmp, ones(p,1), ones(q,1));
        allresults = [char_name; data];
        xlswrite([save_path,param.method,'_',param.dataset,'_Fmeasure'], allresults);
        clear tmp results allresults
    end
end

%% get average Precision100
for i = 1:length(param.datasets)
    param.dataset = param.datasets{i};
    for j = 1:length(param.methods)
        param.method = param.methods{j};
        tmp = cell2mat(Precision100{j});
        mean_pre100 = mean(tmp,2);
        std_pre100 = std(tmp');
        results = [mean_pre100,std_pre100'];
        char_name = {'bits','pre100_mean','pre100_std'};
        tmp = [param.bits',results];
        [p,q] = size(tmp);
        data = mat2cell(tmp, ones(p,1), ones(q,1));
        allresults = [char_name; data];
        xlswrite([save_path,param.method,'_',param.dataset,'_Precision100'], allresults);
        clear tmp results allresults
    end
end

%% show Rec vs. Pre curve
for i = 1:length(param.datasets)
    param.dataset = param.datasets{i};
    for m = 1:length(param.bits)
        param.bit = param.bits(m);
        for j = 1:length(param.methods)
            param.method = param.methods{j};
            tmp_rec = zeros(length(Rec{j}{m,1}),1);
            tmp_pre = zeros(length(Pre{j}{m,1}),1);
            for n = 1:param.runtimes
                tmp = Rec{j}{m,n};
                tmp_rec = tmp_rec + tmp;
                clear tmp
                tmp = Pre{j}{m,n};
                tmp_pre = tmp_pre + tmp;
                clear tmp
            end
            tmp_rec = tmp_rec./param.runtimes;
            tmp_pre = tmp_pre./param.runtimes;
            % show the line
            p = plot(tmp_rec, tmp_pre);
            clear tmp_rec tmp_pre
            color = get_color(j);
            marker = get_marker(j);
            set(p,'Color', color)
            set(p,'Marker', marker);
            set(p,'LineWidth', line_width);
            set(p,'MarkerSize', marker_size);
            hold on
        end
        h1 = xlabel(['Recall @ ', num2str(param.bit), ' bits']);
        h2 = ylabel('Precision');
        set(h1, 'FontSize', xy_font_size);
        set(h2, 'FontSize', xy_font_size);
        hleg = legend(param.methods);
        set(hleg,'Location', 'northeast');
        set(hleg, 'FontSize', legend_font_size);
        set(gca, 'linewidth', linewidth);
        set(gca, 'linewidth', linewidth);
        title(param.dataset, 'FontSize', title_font_size);
        grid on;
        saveas(p,[save_path,param.dataset,'_',num2str(param.bit),'_final_PR.png']);
        saveas(p,[save_path,param.dataset,'_',num2str(param.bit),'_final_PR.eps']);
        hold off
    end
end

%% show Precision vs. the number of retrieved sample.
for i = 1:length(param.datasets)
    param.dataset = param.datasets{i};
    for m = 1:length(param.bits)
        param.bit = param.bits(m);
        for j = 1:length(param.methods)
            param.method = param.methods{j};
            tmp_pre = zeros(1,length(Precision{j}{m,1}));
            for n = 1:param.runtimes
                tmp = Precision{j}{m,n};
                tmp_pre = tmp_pre + tmp;
                clear tmp
            end
            tmp_pre = tmp_pre./param.runtimes;
            % show the line
            p = plot(param.pos(1,1:end),tmp_pre(1,1:end));
            clear tmp_pre
            color = get_color(j);
            marker = get_marker(j);
            set(p,'Color', color)
            set(p,'Marker', marker);
            set(p,'LineWidth', line_width);
            set(p,'MarkerSize', marker_size);
            hold on
        end
        xlim([0,Len]);
        h1 = xlabel('The number of searched instances');
        h2 = ylabel(['Precision @ ', num2str(param.bit), ' bits']);
        set(h1, 'FontSize', xy_font_size);
        set(h2, 'FontSize', xy_font_size);
        hleg = legend(param.methods);
        set(hleg,'Location', 'northeast');
        set(hleg, 'FontSize', legend_font_size);
        set(gca, 'linewidth', linewidth);
        set(gca, 'linewidth', linewidth);
        title(param.dataset, 'FontSize', title_font_size);
        grid on;
        saveas(p,[save_path,param.dataset,'_',num2str(param.bit),'_PreVsNum.png']);
        saveas(p,[save_path,param.dataset,'_',num2str(param.bit),'_PreVsNum.eps']);
        hold off
    end
end

%% show Recall vs. the number of retrieved sample.
for i = 1:length(param.datasets)
    param.dataset = param.datasets{i};
    for m = 1:length(param.bits)
        param.bit = param.bits(m);
        for j = 1:length(param.methods)
            param.method = param.methods{j};
            tmp_rec = zeros(1,length(Recall{j}{m,1}));
            for n = 1:param.runtimes
                tmp = Recall{j}{m,n};
                tmp_rec = tmp_rec + tmp;
                clear tmp
            end
            tmp_rec = tmp_rec./param.runtimes;
            % show the line
            p = plot(param.pos(1,1:end),tmp_rec(1,1:end));
            clear tmp_rec
            color = get_color(j);
            marker = get_marker(j);
            set(p,'Color', color)
            set(p,'Marker', marker);
            set(p,'LineWidth', line_width);
            set(p,'MarkerSize', marker_size);
            hold on
        end
        xlim([0,Len]);
        h1 = xlabel('The number of searched instances');
        h2 = ylabel(['Recall @ ', num2str(param.bit), ' bits']);
        set(h1, 'FontSize', xy_font_size);
        set(h2, 'FontSize', xy_font_size);
        hleg = legend(param.methods);
        set(hleg,'Location', 'southeast');
        set(hleg, 'FontSize', legend_font_size);
        set(gca, 'linewidth', linewidth);
        set(gca, 'linewidth', linewidth);
        title(param.dataset, 'FontSize', title_font_size);
        grid on;
        saveas(p,[save_path,param.dataset,'_',num2str(param.bit),'_RecVsNum.png']);
        saveas(p,[save_path,param.dataset,'_',num2str(param.bit),'_RecVsNum.eps']);
        hold off
    end
end

end