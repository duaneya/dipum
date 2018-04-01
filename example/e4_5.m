clc,clear,close all;
f = imread('Fig0405(a)[without_noise].tif');
[M, N] = size(f);
R = imnoise2('salt & pepper', M, N, 0.1, 0);
gp = f;
gp(R == 0) = 0;
figure
subplot(231),imshow(gp, [])
R = imnoise2('salt & pepper', M, N, 0, 0.1);
gs = f;
gs(R == 1) = 255;
subplot(232),imshow(gs, [])
fp = spfilt(gp, 'chmean', 3, 3, 1.5);
subplot(233),imshow(fp, [])
fs = spfilt(gs, 'chmean', 3, 3, -1.5);
subplot(234),imshow(fs, [])
fpmax = spfilt(gp, 'max', 3, 3);
subplot(235),imshow(fpmax, [])
fsmin = spfilt(gs, 'min', 3, 3);
subplot(236),imshow(fsmin, [])
