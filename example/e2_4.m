clc,clear,close all;
f = imread('Fig0203(a).tif');
figure
subplot(221),imhist(f)
h = imhist(f,25);
horz = linspace(0,255,25);
subplot(222),bar(horz,h)
axis([0 255 0 60000])
set(gca, 'xtick', 0:50:255)
set(gca, 'ytick', 0:20000:60000)
subplot(223),stem(horz,h,'fill')
axis([0 255 0 60000])
set(gca, 'xtick', 0:50:255)
set(gca, 'ytick', 0:20000:60000)
hc = imhist(f);
subplot(224),plot(hc)
axis([0 255 0 15000])
set(gca, 'xtick', 0:50:255)
set(gca, 'ytick', 0:20000:15000)