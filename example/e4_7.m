clc,clear,close all;
f = checkerboard(8);
PSF = fspecial('motion', 7, 45);
gb = imfilter(f, PSF, 'circular');
PSF
noise = imnoise2('gaussian', size(f, 1), size(f, 2), 0, sqrt(0.001));
g = gb + noise;
figure
subplot(221),imshow(pixeldup(f, 8), [])
subplot(222),imshow(pixeldup(gb, 8), [])
subplot(223),imshow(noise, [])
subplot(224),imshow(pixeldup(g, 8), [])
