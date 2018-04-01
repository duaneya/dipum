clc,clear,close all;
f2 = imread('shuttle.tif', 2);
ntrop(f2)
e2 = mat2lpc(f2);
ntrop(e2,512)
c2 = mat2huff(e2);
imratio(f2,c2)
f1 = imread('shuttle.tif', 1);
ne2 = double(f2) - double(f1);
ntrop(ne2,512)
nc2 = mat2huff(ne2);
imratio(f2,nc2)