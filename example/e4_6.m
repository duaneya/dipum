clc,clear,close all;
f = imread('Fig0406(a)[without_noise].tif');
g = imnoise(f, 'salt & pepper', .25);
f1 = medfilt2(g, [7 7], 'symmetric');
f2 = adpmedian(g, 7);
figure
subplot(131),imshow(g, [])
subplot(132),imshow(f1, [])
subplot(133),imshow(f2, [])