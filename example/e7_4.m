clc,clear,close all;
f = imread('Fig1006(a).tif');
f = tofloat(f);
[gSobel_default, ts] = edge(f, 'sobel');
[gLoG_default, ts] = edge(f, 'log');
[gCanny_default, ts] = edge(f, 'canny');
gSobel_best = edge(f, 'sobel', 0.05);
gLoG_best = edge(f, 'log', 0.003, 2.25);
gCanny_best = edge(f, 'canny', [0.04 0.10], 1.5);
figure
subplot(321),imshow(gSobel_default)
subplot(322),imshow(gSobel_best)
subplot(323),imshow(gLoG_default)
subplot(324),imshow(gLoG_best)
subplot(325),imshow(gCanny_default)
subplot(326),imshow(gCanny_best)