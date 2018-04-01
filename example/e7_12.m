clc,clear,close all;
f = tofloat(imread('Fig1017(a).tif'));
figure
subplot(221),imshow(f)
[TGlobal] = graythresh(f);
gGlobal = im2bw(f, TGlobal);
subplot(222),imshow(gGlobal)
g = localthresh(f, ones(3), 30, 1.5, 'global');
SIG = stdfilt(f, ones(3));
subplot(223),imshow(SIG, [])
subplot(224),imshow(g)