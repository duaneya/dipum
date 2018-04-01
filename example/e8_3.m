clc,clear,close all;
g = bwperim(f, 8);
Q = qtdecomp(g, 0, 2);
R = imfill(gF, 'holes') & g;
B = bwboundaries(f, 4, 'noholes');
b = B{1};