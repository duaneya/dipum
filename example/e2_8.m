clc,clear,close all;
w = ones(31);
f = imread('Fig0216(a).tif');
figure
subplot(231),imshow(f,[])
gd = imfilter(f,w);
subplot(232),imshow(gd,[]);
gr = imfilter(f,w,'replicate');
subplot(233),imshow(gr,[])
gs = imfilter(f,w,'symmetric');
subplot(234),imshow(gs,[]);
gc = imfilter(f,w,'circular');
subplot(235),imshow(gc,[]);
f8 = im2uint8(f);
g8r = imfilter(f8,w,'replicate');
subplot(236),imshow(g8r,[])
