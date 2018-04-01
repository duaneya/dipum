clc,clear,close all;
f = imread('Fig1002(a).tif');
w = [-1 -1 -1; -1 8 -1; -1 -1 -1];
g = abs(imfilter(tofloat(f),w));
T = max(g(:));
g = g >= T;
figure
subplot(121),imshow(f)
subplot(122),imshow(g)