clc,clear,close all;
f = imread('Fig0217(a).tif');
w = fspecial('laplacian',0)
g1 = imfilter(f,w,'replicate');
figure
subplot(221),imshow(f,[])
subplot(222),imshow(g1,[])
f2 = tofloat(f);
g2=imfilter(f2,w,'replicate');
subplot(223),imshow(g2,[])
g = f2-g2;
subplot(224),imshow(g);