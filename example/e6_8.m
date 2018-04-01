clc,clear,close all;
f = imread('Fig0804(a).tif');
c1 = im2jpeg(f);
f1 = jpeg2im(c1);
imratio(f,c1)
compare(f,f1,3)
c4 = im2jpeg(f, 4);
f4 = jpeg2im(c4);
imratio(f, c4)
compare(f,f4,3)