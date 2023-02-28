function marker = get_marker(curve_idx)

markers=[];
markers{end+1}='o';
markers{end+1}='s';
markers{end+1}='h';
markers{end+1}='<';
markers{end+1}='*';

markers{end+1}='o';
markers{end+1}='s';
markers{end+1}='h';
markers{end+1}='<';
markers{end+1}='*';

markers{end+1}='o';
markers{end+1}='s';
markers{end+1}='h';
markers{end+1}='<';
markers{end+1}='*';

markers{end+1}='o';
markers{end+1}='s';
markers{end+1}='h';
markers{end+1}='<';
markers{end+1}='*';

sel_idx=mod(curve_idx-1, length(markers))+1;
marker=markers{sel_idx};

end
