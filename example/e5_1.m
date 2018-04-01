clc,clear,close all;
f = imread('Fig0604(a).tif');
[X1, map1] = rgb2ind(f, 8, 'nodither');
figure
subplot(231),imshow(f)
subplot(232),imshow(X1, map1)
[X2, map2] = rgb2ind(f, 8, 'dither');
subplot(233),imshow(X2, map2)
g = rgb2gray(f);
g1 = dither(g);
subplot(234),imshow(g)
subplot(235),imshow(g1)