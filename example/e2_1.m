clc,clear,close all;
f = imread('Fig0203(a).tif');
g1 = imadjust(f, [0 1], [1 0]);
figure
subplot(231)
imshow(f,[])
subplot(232)
imshow(g1,[])
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [], [], 2);
subplot(233)
imshow(g2,[])
subplot(234)
imshow(g3,[])
g4 = imadjust(f, stretchlim(f),[]);
g5 = imadjust(f, stretchlim(f),[1 0]);
subplot(235)
imshow(g4,[]);
subplot(236)
imshow(g5,[])