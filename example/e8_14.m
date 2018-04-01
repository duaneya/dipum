clc,clear,close all;
f1 = imread('Fig1130(a).tif');
f2 = imread('Fig1130(b).tif');
f3 = imread('Fig1130(c).tif');
f4 = imread('Fig1130(d).tif');
f5 = imread('Fig1130(e).tif');
f6 = imread('Fig1130(f).tif');
figure
subplot(321),imshow(f1)
subplot(322),imshow(f2)
subplot(323),imshow(f3)
subplot(324),imshow(f4)
subplot(325),imshow(f5)
subplot(326),imshow(f6)

S = cat(3,f1,f2,f3,f4,f5,f6);
X = imstack2vectors(S);
P = principalcomps(X,6);
g1 = P.Y(:,1);
g1 = reshape(g1,512,512);
g2 = P.Y(:,2);
g2 = reshape(g2,512,512);
g3 = P.Y(:,3);
g3 = reshape(g3,512,512);
g4 = P.Y(:,4);
g4 = reshape(g4,512,512);
g5 = P.Y(:,5);
g5 = reshape(g5,512,512);
g6 = P.Y(:,6);
g6 = reshape(g6,512,512);
figure
subplot(321),imshow(g1,[])
subplot(322),imshow(g2,[])
subplot(323),imshow(g3,[])
subplot(324),imshow(g4,[])
subplot(325),imshow(g5,[])
subplot(326),imshow(g6,[])
d = diag(P.Cy);
P = principalcomps(X,2);
h1 = P.X(:,1);
h1 = mat2gray(reshape(h1,512,512));
D1 = tofloat(f1) - h1;

h2 = P.X(:,2);
h2 = mat2gray(reshape(h2,512,512));
D2 = tofloat(f2) - h2;

h3 = P.X(:,3);
h3 = mat2gray(reshape(h3,512,512));
D3 = tofloat(f2) - h3;

h4 = P.X(:,4);
h4 = mat2gray(reshape(h4,512,512));
D4 = tofloat(f4) - h4;

h5 = P.X(:,5);
h5 = mat2gray(reshape(h5,512,512));
D5 = tofloat(f5) - h5;

h6 = P.X(:,6);
h6 = mat2gray(reshape(h6,512,512));
D6 = tofloat(f6) - h6;
figure
subplot(321),imshow(D1,[])
subplot(322),imshow(D2,[])
subplot(323),imshow(D3,[])
subplot(324),imshow(D4,[])
subplot(325),imshow(D5,[])
subplot(326),imshow(D6,[])
P.ems
figure
subplot(121),imshow(abs(D1 - tofloat(f1)))
subplot(122),imshow(abs(D6 - tofloat(f6)))