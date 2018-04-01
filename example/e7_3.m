clc,clear,close all;
f = imread('Fig1006(a).tif');
[gv, t] = edge(f, 'sobel', 'vertical');
figure
subplot(321),imshow(f)
subplot(322),imshow(gv)
t
gv =edge(f, 'sobel', 0.15, 'vertical');
subplot(323),imshow(gv)
gboth = edge(f, 'sobel', 0.15);
subplot(324),imshow(gboth)
wneg45 = [-2 -1 0; -1 0 1; 0 1 2]
gneg45 = imfilter(tofloat(f), wneg45, 'replicate');
T = 0.3*max(abs(gneg45(:)));
gneg45 = gneg45 >= T;
subplot(325),imshow(gneg45)
wpos45 = [0 1 2; -1 0 1; -2 -1 0]
gpos45 = imfilter(tofloat(f), wpos45, 'replicate');
T = 0.3*max(abs(gpos45(:)));
gpos45 = gpos45 >= T;
subplot(326),imshow(gpos45)