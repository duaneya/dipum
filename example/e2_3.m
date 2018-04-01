clc,clear,close all;
f = imread('Fig0206(a).tif');
g = intrans(f, 'stretch', mean2(tofloat(f)),0.9);
figure
subplot(121),imshow(f,[])
subplot(122),imshow(g,[])
