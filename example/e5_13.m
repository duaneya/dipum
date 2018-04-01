clc,clear,close all;
f = imread('Fig0630(a).tif');
mask = roipoly(f);
red = immultiply(mask, f(:,:,1));
green = immultiply(mask, f(:,:,2));
blue = immultiply(mask, f(:,:,3));
g = cat(3,red,green,blue);
figure
subplot(121),imshow(f)
subplot(122),imshow(g)
[M, N, K] = size(g);
I = reshape(g, M * N, 3);
idx = find(mask);
I = double(I(idx, 1:3));
[C, m] = covmatrix(I);
d = diag(C);
sd = sqrt(d)
E25 = colorseg('euclidean', f, 25, m);
E50 = colorseg('euclidean', f, 50, m);
E75 = colorseg('euclidean', f, 75, m);
E100 = colorseg('euclidean', f, 100, m);
figure
subplot(241),imshow(E25)
subplot(242),imshow(E50)
subplot(243),imshow(E75)
subplot(244),imshow(E100)
E25 = colorseg('mahalanobis', f, 25, m);
E50 = colorseg('mahalanobis', f, 50, m);
E75 = colorseg('mahalanobis', f, 75, m);
E100 = colorseg('mahalanobis', f, 100, m);
subplot(245),imshow(E25)
subplot(246),imshow(E50)
subplot(247),imshow(E75)
subplot(248),imshow(E100)