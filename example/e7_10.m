clc,clear,close all;
f = tofloat(imread('Fig1016(a).tif'));
figure
subplot(231),imshow(f)
subplot(232),imhist(f)
sx = fspecial('sobel');
sy = sx';
gx = imfilter(f, sx, 'replicate');
gy = imfilter(f, sy, 'replicate');
grad = sqrt(gx.*gx + gy.*gy);
grad = grad/max(grad(:));
h = imhist(grad);
Q = percentile2i(h, 0.999);
markerImage = grad > Q;
subplot(233),imshow(markerImage)
fp = f.*markerImage;
subplot(234),imshow(fp)
hp = imhist(fp);
hp(1) = 0;
subplot(235),bar(hp)
T = otsuthresh(hp);
g = im2bw(f, T);
subplot(236),imshow(g)