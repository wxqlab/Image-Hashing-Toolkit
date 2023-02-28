function [dist] = distLf(U1,U2,ind,s)

mu1 = mat2cell(U1,ind,s);
mu2 = mat2cell(U2,ind,s);
vec1 = cellfun(@(x)(x(:))',mu1,'un',0);
vec2 = cellfun(@(x)(x(:))',mu2,'un',0);
vec1 = cell2mat(vec1);
vec2 = cell2mat(vec2);

x = vec1';
c = vec2';
[~,nx] = size(x);
[~,nc] = size(c);
x2 = sum(x.^2,1);
c2 = sum(c.^2,1);
dist = sqrt(max(0,repmat(c2,nx,1)+repmat(x2',1,nc)-2*x'*c));

end