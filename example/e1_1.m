clc,clear,close all;

%%
timeit(@() twodsin1(1, 1/(4*pi), 1/(4*pi), 512, 512)) %0.0118

%%
f = twodsin1(1, 1/(4*pi), 1/(4*pi), 512, 512);
imshow(f, [])
%%
timeit(@() twodsin2(1, 1/(4*pi), 1/(4*pi), 512, 512)) %0.0050
