clc,clear,close all;
load SqueezeTracy;
g = huff2mat(c);
f = imread('Fig0804(a).tif');
rmse = compare(f, g)