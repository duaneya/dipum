clc,clear,close all;
f = imread('Fig0313(a).tif');
[f, revertclass] = tofloat(f);
PQ = paddedsize(size(f));
[U, V] = dftuv(PQ(1), PQ(2));
D = hypot(U, V);
D0 = 0.05*PQ(2);
F = fft2(f,PQ(1),PQ(2));
H = exp(-(D.^2)/(2*(D0^2)));
g = dftfilt(f,H);
g = revertclass(g);
figure
subplot(141),imshow(f,[])
subplot(142),imshow(fftshift(H))
subplot(143),imshow(log(1 + abs(fftshift(F))),[])
subplot(144),imshow(g)
