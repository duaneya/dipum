clc,clear,close all;
f = zeros(101, 101);
f(1,1) = 1;f(101,1) = 1; f(1,101) = 1;
f(101, 101) = 1; f(51,51) = 1;
H = hough(f);
subplot(221),imshow(f,[])
subplot(222),imshow(H, [])
[H, theta, rho] = hough(f);
subplot(223),imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit')
axis on,axis normal
xlabel('\theta'),ylabel('\rho')