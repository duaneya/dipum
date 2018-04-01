clc,clear,close all;
f = imread('Fig0208(a).tif');
figure
subplot(221),imshow(f,[]);
g = histeq(f,256);
subplot(222),imhist(f),ylim('auto');
subplot(223),imshow(g,[]);
subplot(224),imhist(g),ylim('auto');
hnorm = imhist(f)./numel(f);
cdf = cumsum(hnorm);
figure
x = linspace(0,1,256);
plot(x,cdf)
axis([0 1 0 1]);
set(gca,'xtick',0:.2:1)
set(gca,'ytick',0:.2:1)
xlabel('Input intensity values','fontsize',9)
ylabel('Output intensity values','fontsize',9)
