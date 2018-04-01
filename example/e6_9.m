clc,clear,close all;
f = imread('Fig0804(a).tif');
c1 = im2jpeg2k(f,5,[8 8.5]);
f1 = jpeg2k2im(c1);
rms1 = compare(f,f1)
cr1 = imratio(f,c1)
c2 = im2jpeg2k(f,5,[8 7]);
f2 = jpeg2k2im(c2);
rms2 = compare(f,f2)
cr2 = imratio(f,c2)
c3 = im2jpeg2k(f,1,[1 1 1 1]);
f3 = jpeg2k2im(c3);
rms3 = compare(f,f3)
cr3 = imratio(f,c3)