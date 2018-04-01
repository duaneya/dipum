clc,clear,close all;
f= tofloat(~imread('Fig1026(a).tif'));
g = im2bw(f, graythresh(f));
gc = ~g;
D = bwdist(gc);
L = watershed(-D);
w = L == 0;
g2 = g & ~w;
figure
subplot(321),imshow(g)
subplot(322),imshow(gc)
subplot(323),imshow(D)
subplot(324),imshow(w)
subplot(325),imshow(g2)