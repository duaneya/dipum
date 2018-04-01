clc,clear,close all;
H1 = fftshift(hpfilter('ideal',500,500,50));
H2 = fftshift(hpfilter('btw',500,500,50));
H3 = fftshift(hpfilter('gaussian',500,500,50));
figure
subplot(231),mesh(double(H1(1:10:500,1:10:500)));
axis tight
colormap([0 0 0])
axis off
subplot(234),imshow(H1,[])
subplot(232),mesh(double(H2(1:10:500,1:10:500)));
axis tight
colormap([0 0 0])
axis off
subplot(235),imshow(H2,[])
subplot(233),mesh(double(H3(1:10:500,1:10:500)));
axis tight
colormap([0 0 0])
axis off
subplot(236),imshow(H3,[])