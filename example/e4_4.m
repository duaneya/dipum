clc,clear,close all;
f = imread('Fig0404(a).tif');
[B, c, r] = roipoly(f);
%B = imread('Fig0404(b).tif');
%[c, r] = size(B);
[h, npix] = histroi(f, c, r);
figure
subplot(221),imshow(f, [])
subplot(222),imshow(B, [])
subplot(223),bar(h, 1)
[v, unv] = statmoments(h, 2);
v
unv
X = imnoise2('gaussian', npix, 1, 147, 20);
subplot(224),hist(X, 130),axis([0 300 0 140])