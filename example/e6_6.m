clc,clear,close all;
f = imread('Fig0810(a).tif');
q1 = quantize(f, 16);
q2 = quantize(f, 16, 'igs');
figure
subplot(131),imshow(f)
subplot(132),imshow(q1)
subplot(133),imshow(q2)