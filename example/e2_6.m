clc,clear,close all;
f = imread('Fig0210(a).tif');
f1 = histeq(f,256);
figure
subplot(221),imshow(f,[]);
subplot(222),imhist(f),ylim('auto');
subplot(223),imshow(f1,[]);
subplot(224),imhist(f1),ylim('auto');
p = twomodegauss(0.15,0.05,0.75,0.05,1,0.07,0.002);
figure
subplot(221),plot(p),xlim([0 255]);
g = histeq(f, p);
subplot(222),imshow(g);
subplot(223),imhist(g),ylim('auto');