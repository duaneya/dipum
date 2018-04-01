clc,clear,close all;
f = imread('Fig0217(a).tif');
w4 = fspecial('laplacian',0);
w8 = [1 1 1;1 -8 1;1 1 1];
f = tofloat(f);
g4 = f - imfilter(f,w4,'replicate');
g8 = f - imfilter(f,w8,'replicate');
figure
subplot(131),imshow(f)
subplot(132),imshow(g4)
subplot(133),imshow(g8)
