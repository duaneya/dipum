clc,clear,close all;
f = imread('Fig0804(a).tif');
c = mat2huff(f);
cr1 = imratio(f, c)
save SqueezeTracy c;
cr2 = imratio('../DIP/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Ed_CH08_Images/Fig0804(a).tif', 'SqueezeTracy.mat')