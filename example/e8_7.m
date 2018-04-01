clc,clear,close all;
f = imread('Fig1116(a).tif');
figure
subplot(121),imshow(f)
b = bwboundaries(f, 'noholes');
b = b{1};
bim = bound2im(b, size(f, 1), size(f, 2));
subplot(122),imshow(bim)
z = frdescp(b);
s546 = ifrdescp(z, 546);
s546im = bound2im(s546, size(f, 1), size(f, 2));
s110 = ifrdescp(z, 110);
s110im = bound2im(s110, size(f, 1), size(f, 2));
s56 = ifrdescp(z, 56);
s56im = bound2im(s56, size(f, 1), size(f, 2));
s28 = ifrdescp(z, 28);
s28im = bound2im(s28, size(f, 1), size(f, 2));
s14 = ifrdescp(z, 14);
s14im = bound2im(s14, size(f, 1), size(f, 2));
s8 = ifrdescp(z, 8);
s8im = bound2im(s8, size(f, 1), size(f, 2));
figure
subplot(231),imshow(s546im)
subplot(232),imshow(s110im)
subplot(233),imshow(s56im)
subplot(234),imshow(s28im)
subplot(235),imshow(s14im)
subplot(236),imshow(s8im)