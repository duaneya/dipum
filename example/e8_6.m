clc,clear,close all;
f = imread('Fig1113(a).tif');
figure
subplot(231),imshow(f)
h = fspecial('gaussian', 25, 15);
g = tofloat(imfilter(f, h, 'replicate'));
subplot(232),imshow(g)
g = im2bw(g, 1.5*graythresh(g));
subplot(233),imshow(g)
s = bwmorph(g, 'skel', Inf);
subplot(234),imshow(s)
s1 = bwmorph(s, 'spur', 8);
subplot(235),imshow(s1)
s2 = bwmorph(s, 'spur', 7);
subplot(236),imshow(s2)