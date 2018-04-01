clc,clear,close all;
f = imread('Fig0210(a).tif');
g1 = adapthisteq(f);
g2 = adapthisteq(f,'NumTiles',[25 25]);
g3 = adapthisteq(f, 'NumTiles',[25 25],'ClipLimit',0.05);
figure
subplot(141),imshow(f,[])
subplot(142),imshow(g1,[])
subplot(143),imshow(g2,[])
subplot(144),imshow(g3,[])