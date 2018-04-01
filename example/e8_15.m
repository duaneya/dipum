clc,clear,close all;
f = im2bw(imread('Fig1134(a).tif'));
[x1 x2] = find(f);
X = [x1 x2];
P = principalcomps(X, 2);
A = P.A;
Y = (A*(X'))';
miny1 = min(Y(:,1));
miny2 = min(Y(:,2));
y1 = round(Y(:,1) - miny1 + min(x1));
y2 = round(Y(:,2) - miny2 + min(x2));
idx = sub2ind(size(f),y1,y2);
fout = false(size(f));
fout(idx) = 1;
fout = imclose(fout, ones(3));
fout = rot90(fout,2);
figure
subplot(231),imshow(f)
subplot(234),imshow(fout)

f = im2bw(imread('Fig1134(b).tif'));
[x1 x2] = find(f);
X = [x1 x2];
P = principalcomps(X, 2);
A = P.A;
Y = (A*(X'))';
miny1 = min(Y(:,1));
miny2 = min(Y(:,2));
y1 = round(Y(:,1) - miny1 + min(x1));
y2 = round(Y(:,2) - miny2 + min(x2));
idx = sub2ind(size(f),y1,y2);
fout = false(size(f));
fout(idx) = 1;
fout = imclose(fout, ones(3));
fout = rot90(fout,2);
subplot(232),imshow(f)
subplot(235),imshow(fout)

f = im2bw(imread('Fig1134(c).tif'));
[x1 x2] = find(f);
X = [x1 x2];
P = principalcomps(X, 2);
A = P.A;
Y = (A*(X'))';
miny1 = min(Y(:,1));
miny2 = min(Y(:,2));
y1 = round(Y(:,1) - miny1 + min(x1));
y2 = round(Y(:,2) - miny2 + min(x2));
idx = sub2ind(size(f),y1,y2);
fout = false(size(f));
fout(idx) = 1;
fout = imclose(fout, ones(3));
fout = rot90(fout,2);
subplot(233),imshow(f)
subplot(236),imshow(fout)
