clc,clear,close all;
f = imread('Fig0205(a).tif');
g = im2uint8(mat2gray(log(1 + double(f))));
figure
subplot(121)
imshow(f,[])
subplot(122)
imshow(g,[])