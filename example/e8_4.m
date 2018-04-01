clc,clear,close all;
f = imread('Fig1107(a).tif');
figure
subplot(321),imshow(f)
B = bwboundaries(f, 4, 'noholes');
b = B{1};
[M, N] = size(f);
bOriginal = bound2im(b, M, N);
subplot(322),imshow(bOriginal)
[X, Y] = im2minperpoly(f, 2);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(323),imshow(bCellsize2)

[X, Y] = im2minperpoly(f, 3);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(324),imshow(bCellsize2)

[X, Y] = im2minperpoly(f, 4);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(325),imshow(bCellsize2)

[X, Y] = im2minperpoly(f, 8);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(326),imshow(bCellsize2)

figure
[X, Y] = im2minperpoly(f, 10);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(221),imshow(bCellsize2)

[X, Y] = im2minperpoly(f, 16);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(222),imshow(bCellsize2)

[X, Y] = im2minperpoly(f, 20);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(223),imshow(bCellsize2)

[X, Y] = im2minperpoly(f, 32);
b2 = connectpoly(X, Y);
bCellsize2 = bound2im(b2, M, N);
subplot(224),imshow(bCellsize2)