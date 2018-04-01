clc,clear,close all;
fR = imread('Fig0627(a).tif');
fG = imread('Fig0627(b).tif');
fB = imread('Fig0627(c).tif');
f = cat(3,fR,fG,fB);
[VG, A, PPG] = colorgrad(f);
figure
subplot(231),imshow(fR)
subplot(232),imshow(fG)
subplot(233),imshow(fB)
subplot(234),imshow(f)
subplot(235),imshow(VG)
subplot(236),imshow(PPG)
f2 = imread('Fig0628(a).tif');
[VG, A, PPG] = colorgrad(f2);
figure
subplot(141),imshow(f2)
subplot(142),imshow(VG)
subplot(143),imshow(PPG)
subplot(144),imshow(gscale(abs(VG - PPG),'minmax',0,1))