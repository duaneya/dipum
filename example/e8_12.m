clc,clear,close all;
f1 = imread('Fig1126(a).tif');
f2 = imread('Fig1126(b).tif');
f1_fft = fftshift(fft2(f1));
f2_fft = fftshift(fft2(f2));
figure
subplot(221),imshow(f1)
subplot(222),imshow(f2)
subplot(223),imshow(im2uint8(mat2gray(log(1+double(abs(f1_fft))))),[])
subplot(224),imshow(im2uint8(mat2gray(log(1+double(abs(f2_fft))))),[])
[srad, sang, S] = specxture(f1);
figure
subplot(221),plot(srad)
subplot(222),plot(sang)
[srad, sang, S] = specxture(f2);
subplot(223),plot(srad)
subplot(224),plot(sang)