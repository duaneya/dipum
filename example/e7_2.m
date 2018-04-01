clc,clear,close all;
f = imread('Fig1004(a).tif');
w = [2 -1 -1; -1 2 -1; -1 -1 2];
g = imfilter(tofloat(f),w);
figure
subplot(321),imshow(f)
subplot(322),imshow(g,[])
gtop = g(1:120,1:120);
gtop = pixeldup(gtop,4);
subplot(323),imshow(gtop,[])
gbot = g(end - 119:end, end - 119:end);
gbot = pixeldup(gbot, 4);
subplot(324),imshow(gbot, [])
g = abs(g);
subplot(325),imshow(g, [])
T = max(g(:));
g = g >= T;
subplot(326),imshow(g)