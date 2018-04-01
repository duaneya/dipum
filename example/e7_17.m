clc,clear,close all;
f = imread('Fig1027(a).tif'); 
h = fspecial('sobel');
fd = tofloat(f);
g = sqrt(imfilter(fd, h, 'replicate') .^ 2 +  ...
    imfilter(fd, h', 'replicate') .^ 2);
L = watershed(g);
wr = L == 0;
g2 = imclose(imopen(g, ones(3,3)), ones(3,3));
L2 = watershed(g2);
wr2 = L2 == 0;
f2 = f;
f2(wr2) = 255;
figure
subplot(221),imshow(f)
subplot(222),imshow(g)
subplot(223),imshow(wr)
subplot(224),imshow(f2)