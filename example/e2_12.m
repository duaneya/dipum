clc,close,close all;
f = imread('Fig0219(a).tif');
fn = imnoise(f,'salt & pepper',0.2);
gm = medfilt2(fn);
gms = medfilt2(fn,'symmetric');
figure
subplot(141),imshow(f)
subplot(142),imshow(fn)
subplot(143),imshow(gm)
subplot(144),imshow(gms)