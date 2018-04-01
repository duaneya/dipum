clc,clear,close all;
H = fftshift(lpfilter('gaussian', 500, 500, 50));
figure
subplot(221),mesh(double(H(1:10:500,1:10:500)))
axis tight
subplot(222),mesh(double(H(1:10:500,1:10:500)))
colormap([0 0 0])
axis off
subplot(223),mesh(double(H(1:10:500,1:10:500)))
colormap([0 0 0])
axis off
view(-25,30)
subplot(224),mesh(double(H(1:10:500,1:10:500)))
colormap([0 0 0])
axis off
view(-25,0)
figure
subplot(121),surf(double(H(1:10:500,1:10:500)))
axis tight
colormap(gray)
axis off
subplot(122),surf(double(H(1:10:500,1:10:500)))
axis tight
colormap(gray)
axis off
shading interp