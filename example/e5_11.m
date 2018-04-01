clc,clear,close all;
fb = imread('Fig0625(a).tif');
lapmask = [1 1 1;1 -8 1;1 1 1];
fb = tofloat(fb);
fen = fb - imfilter(fb, lapmask, 'replicate');
figure
subplot(121),imshow(fb)
subplot(122),imshow(fen)