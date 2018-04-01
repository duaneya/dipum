clc,clear,close all;
f = imread('Fig1103(a).tif');
figure
subplot(231),imshow(f)
h = fspecial('average', 9);
g = imfilter(f, h, 'replicate');
subplot(232),imshow(g)
gB = im2bw(g, 0.5);
subplot(233),imshow(gB)
B = bwboundaries(gB, 'noholes');
d = cellfun('length', B);
[maxd, k] = max(d);
b = B{k};
[M N] = size(g);
g = bound2im(b, M, N);
subplot(234),imshow(g)
[s, su] = bsubsamp(b, 50);
g2 = bound2im(s, M, N);
subplot(235),imshow(g2)
cn = connectpoly(s(:, 1), s(:, 2));
g3 = bound2im(cn, M, N);
subplot(236),imshow(g3)
c = fchcode(su);
c.x0y0
c.fcc
c.mm
c.diff
c.diffmm