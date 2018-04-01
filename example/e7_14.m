clc,clear,close all;
f = imread('Fig1020(a).tif');
[g, NR, SI, TI] = regiongrow(f, 1, 0.26);
figure
subplot(221),imshow(f)
subplot(222),imshow(g)
subplot(223),imshow(TI)
subplot(224),imshow(SI)
figure
imhist(f)
ylim('auto')