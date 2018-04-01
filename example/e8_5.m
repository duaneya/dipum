clc,clear,close all;
fsq = imread('Fig1111(a).tif');
ftr = imread('Fig1111(b).tif');
figure
subplot(221),imshow(fsq)
subplot(222),imshow(ftr)
bSq = bwboundaries(fsq, 'noholes');
[distSq, angleSq] = signature(bSq{1});
subplot(223),plot(angleSq, distSq)
bSq = bwboundaries(ftr, 'noholes');
[distSq, angleSq] = signature(bSq{1});
subplot(224),plot(angleSq, distSq)