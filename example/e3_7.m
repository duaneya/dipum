clc,clear,close all;
f = imread('Fig0313(a).tif');
PQ= paddedsize(size(f));
D0 = 0.05*PQ(1);
H = hpfilter('gaussian',PQ(1),PQ(2),D0);
g = dftfilt(f,H);
figure
subplot(121),imshow(f)
subplot(122),imshow(g)