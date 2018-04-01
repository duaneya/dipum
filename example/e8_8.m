clc,clear,close all;
f = imread('Fig1119(a).tif');
figure
subplot(321),imshow(f)
CH = cornermetric(f, 'Harris');
CH(CH < 0) = 0;
CH = mat2gray(CH);
subplot(323),imshow(imcomplement(CH))
CM = cornermetric(f, 'MinimumEigenvalue');
CM = mat2gray(CM);
subplot(324),imshow(imcomplement(CM))
hH = imhist(CH);
hM = imhist(CM);
TH = percentile2i(hH, 0.9945);
TM = percentile2i(hM, 0.9970);
cpH = cornerprocess(CH, TH, 1);
cpM = cornerprocess(CM, TM, 1);
subplot(325),imshow(cpH)
subplot(326),imshow(cpM)

[xH yH] = find(cpH);
figure, subplot(221),imshow(f)
hold on
plot(yH(:)', xH(:)', 'wo')
[xM yM] = find(cpM);
subplot(222),imshow(f)
hold on
plot(yM(:)', xM(:)', 'wo')

cpH = cornerprocess(CH, TH, 5);
cpM = cornerprocess(CM, TM, 5);
[xH yH] = find(cpH);
subplot(223),imshow(f)
hold on
plot(yH(:)', xH(:)', 'wo')
[xM yM] = find(cpM);
subplot(224),imshow(f)
hold on
plot(yM(:)', xM(:)', 'wo')