clc,clear,close all;
f = imread('Fig1006(a).tif');
f = tofloat(f);
f = edge(f, 'canny', [0.04 0.10], 1.5);
[H, theta, rho] = hough(f, 'ThetaResolution', 0.2);
figure
subplot(121),imshow(H, [], 'XData',theta,'YData',rho,'InitialMagnification','fit')
axis on,axis normal
xlabel('\theta'),ylabel('\rho')
peaks = houghpeaks(H, 5);
hold on
plot(theta(peaks(:,2)),rho(peaks(:,1)),...
    'linestyle', 'none', 'marker', 's', 'color', 'w')
lines = houghlines(f, theta, rho, peaks);
subplot(122),imshow(f),hold on
for k = 1:length(lines)
    xy = [lines(k).point1 ; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',4,'Color',[.8 .8 .8]);
end