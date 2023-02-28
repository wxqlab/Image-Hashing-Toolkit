%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Sim] = getAnchorW(X, Anchor, s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma = 0;
[n,dim] = size(X);
m = size(Anchor,1);
%% get Z
Z = zeros(n,m);
Dis = sqdist(X',Anchor');
clear X;
clear Anchor;

val = zeros(n,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = min(Dis,[],2);
    tep = (pos(:,i)-1)*n+[1:n]';
    Dis(tep) = 1e60; 
end
clear Dis;
clear tep;
if sigma == 0
   sigma = mean(val(:,s).^0.5);
end
val = exp(-val/(1/1*sigma^2));
val = repmat(sum(val,2).^-1,1,s).*val; %% normalize
tep = (pos-1)*n+repmat([1:n]',1,s);
Z([tep]) = [val];
Z = sparse(Z);
Sim = Z*Z';

clear tep;
clear val;
clear pos;
