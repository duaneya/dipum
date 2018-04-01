clc,clear,close all;
f = imread('Fig0807(c).tif');
e = mat2lpc(f);
figure
subplot(121),imshow(mat2gray(e));
ntrop(e)
c = mat2huff(e);
cr = imratio(f, c)
[h, x] = hist(e(:) * 512, 512);
subplot(122),bar(x, h, 'k');
g = lpc2mat(huff2mat(c));
compare(f, g)