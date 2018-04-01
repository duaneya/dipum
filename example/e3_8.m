clc,clear,close all;
f = imread('Fig0319(a).tif');
PQ = paddedsize(size(f));
D0 = 0.05*PQ(1);
HBW = hpfilter('btw',PQ(1),PQ(2),D0,2);
H = 0.5+2*HBW;
gbw = dftfilt(f,HBW,'fltpoint');
gbw = gscale(gbw);
ghf = dftfilt(f,H,'fltpoint');
ghf = gscale(ghf);
ghe = histeq(ghf,256);
figure
subplot(221),imshow(f,[])
subplot(222),imshow(gbw,[])
subplot(223),imshow(ghf,[])
subplot(224),imshow(ghe,[])
