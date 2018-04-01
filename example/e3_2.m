clc,clear,close all;
f = imread('Fig0309(a).tif');
figure
subplot(121),imshow(f,[])
f = tofloat(f);
F = fft2(f);
S = fftshift(log(1 + abs(F)));
subplot(122),imshow(S, [])
h = fspecial('sobel');
%freqz2(h)
PQ = paddedsize(size(f));
H = freqz2(h, PQ(1), PQ(2));
H1 = ifftshift(H);
figure
subplot(221),mesh(double(abs(H(1:10:1200,1:10:1200)))),axis tight,colormap([0 0 0]),axis off
subplot(222),mesh(double(abs(H1(1:10:1200,1:10:1200)))),axis tight,colormap([0 0 0]),axis off
subplot(223),imshow(abs(H), [])
subplot(224),imshow(abs(H1),[])
gs = imfilter(f, h);
gf = dftfilt(f, H1);
figure
subplot(331),imshow(gs, [])
subplot(322),imshow(gf,[])
subplot(323),imshow(abs(gs),[])
subplot(324),imshow(abs(gf),[])
subplot(325),imshow(abs(gs) > 0.2*abs(max(gs(:))))
subplot(326),imshow(abs(gf) > 0.2*abs(max(gf(:))))
d = abs(gs - gf);
max(d(:))
min(d(:))