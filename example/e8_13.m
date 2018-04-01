clc,clear,close all;
f = imread('Fig1128(a)[original].tif');
fp = padarray(f, [84 84], 'both');
figure
subplot(231),imshow(fp)
ftrans = zeros(568, 568, 'uint8');
ftrans(151:550,151:550) = f;
subplot(232),imshow(ftrans)
fhs = f(1:2:end, 1:2:end);
fhsp = padarray(fhs, [184 184], 'both');
subplot(233),imshow(fhsp)
fm = fliplr(f);
fmp = padarray(fm, [84 84], 'both');
subplot(234),imshow(fmp)
fr45 = imrotate(f, 45, 'bilinear');
fr90 = imrotate(f, 90, 'bilinear');
fr90p = padarray(fr90, [84 84], 'both');
subplot(235),imshow(fr45)
subplot(236),imshow(fr90p)
phi = invmoments(f);
format short e
phi
format short
phinorm = -sign(phi).*(log10(abs(phi)))