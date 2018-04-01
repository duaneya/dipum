clc,clear,close all;
L = linspace(40, 80, 1024);
radius = 70;
theta = linspace(0, pi, 1024);
a = radius * cos(theta);
b = radius * sin(theta);
L = repmat(L, 100, 1);
a = repmat(a, 100, 1);
b = repmat(b, 100, 1);
lab_scale = cat(3, L, a, b);
cform = makecform('lab2srgb');
rgb_scale = applycform(lab_scale, cform);
imshow(rgb_scale)