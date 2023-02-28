function color = get_color(curve_idx)

colors = [];
colors{end+1} = [ 0.3 0.3 0];
colors{end+1} = [ 0.4 0 0.3];
colors{end+1} = [ 0 0.6 0.2];
colors{end+1} = [ 0.5 0 0.2];
colors{end+1} = [0.7 0 0.7 ];
colors{end+1} = [0 0.7 0.7 ];
colors{end+1} = 'b';
colors{end+1} = 'g';
colors{end+1} = 'm';
colors{end+1} = 'c';
colors{end+1} = 'r';
colors{end+1} = [ 0.3 0.3 0];
colors{end+1} = [ 0.4 0 0.3];
colors{end+1} = [ 0 0.6 0.2];
colors{end+1} = [ 0.5 0 0.2];
colors{end+1} = [0.7 0 0.7 ];
colors{end+1} = [0 0.7 0.7 ];

sel_idx = mod(curve_idx-1, length(colors))+1;
color = colors{sel_idx};

end