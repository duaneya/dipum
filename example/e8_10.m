clc,clear,close all;
f1 = imread('Fig1121(a).tif');
f2 = imread('Fig1121(b).tif');
f3 = imread('Fig1121(c).tif');
figure
subplot(231),imshow(f1)
subplot(232),imshow(f2)
subplot(233),imshow(f3)
f1 = imhist(f1);
f2 = imhist(f2);
f3 = imhist(f3);
subplot(234),plot(f1)
subplot(235),plot(f2)
subplot(236),plot(f3)
t = statxture(f1)