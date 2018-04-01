clc,clear,close all;
f = imread('Fig1015(a)[noiseless].tif');
fn = imnoise(f, 'gaussian', 0, 0.038);
figure
subplot(231),imshow(fn)
subplot(232),imhist(fn)
Tn = graythresh(fn);
gn = im2bw(fn, Tn);
subplot(233),imshow(gn)
w = fspecial('average', 5);
fa = imfilter(fn, w, 'replicate');
subplot(234),imshow(fa)
subplot(235),imhist(fa)
Ta = graythresh(fa);
ga = im2bw(fa, Ta);
subplot(236),imshow(ga)