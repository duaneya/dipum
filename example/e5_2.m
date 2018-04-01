clc,clear,close all;
f = imread('Fig0602(b).tif');
hsi = rgb2hsi(f);
figure
subplot(221),imshow(f(:,:,1:3))
subplot(222),imshow(hsi(:,:,1))
subplot(223),imshow(hsi(:,:,2))
subplot(224),imshow(hsi(:,:,3))