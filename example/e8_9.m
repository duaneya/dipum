clc,clear,close all;
B = bwlabel(B);
D = regionprops(B, 'area', 'boundingbox');
A = [D.Area];
NR = numel(A);
V = cat(1, D.BoundingBox);