clc,clear,close all;
f = imread('Fig1028(a).tif');
h = fspecial('sobel');
fd = tofloat(f);
g = sqrt(imfilter(fd, h, 'replicate') .^ 2 + ...
    imfilter(fd, h, 'replicate') .^2);
L = watershed(g);
wr = L == 0;
rm = imregionalmin(g);
im = imextendedmin(f, 2);
fim = f;
fim(im) = 175;
Lim = watershed(bwdist(im));
em = Lim == 0;
g2 = imimposemin(g, im | em);
L2 = watershed(g2);
f2 = f;
f2(L2 == 0) = 255;
figure
subplot(331),imshow(f)
subplot(332),imshow(wr)
subplot(333),imshow(rm)
subplot(334),imshow(fim)
subplot(335),imshow(em)
subplot(336),imshow(g2)
subplot(337),imshow(f2)