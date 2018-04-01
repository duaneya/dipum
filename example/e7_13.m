clc,clear,close all;
f = imread('Fig1019(a).tif');
T = graythresh(f);
g1 = im2bw(f, T);
g2 = movingthresh(f, 20, 0.5);
figure
subplot(231),imshow(f)
subplot(232),imshow(g1)
subplot(233),imshow(g2)
f = imread('Fig1019(d).tif');
T = graythresh(f);
g1 = im2bw(f, T);
g2 = movingthresh(f, 20, 0.5);
subplot(234),imshow(f)
subplot(235),imshow(g1)
subplot(236),imshow(g2)