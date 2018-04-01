clc,clear,close all;
f = tofloat(imread('Fig1017(a).tif'));
figure
subplot(231),imshow(f)
subplot(232),imhist(f)
hf = imhist(f);
[Tf SMF] = graythresh(f);
gf = im2bw(f, Tf);
subplot(233),imshow(gf)
w = [-1 -1 -1; -1 8 -1; -1 -1 -1];
lap = abs(imfilter(f,w,'replicate'));
lap = lap/max(lap(:));
h = imhist(lap);
Q = percentile2i(h, 0.995);
markerImage = lap > Q;
fp = f.*markerImage;
subplot(234),imshow(fp)
hp = imhist(fp);
hp(1) = 0;
subplot(235),bar(hp)
T = otsuthresh(hp);
g = im2bw(f,T);
subplot(236),imshow(g)