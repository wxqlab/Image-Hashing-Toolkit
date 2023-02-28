function [ z ] = sgn( x )
%SGN 此处显示有关此函数的摘要
%   此处显示详细说明
z = x;
z(x<=0) = -1;
z(x>0) = 1;
end

