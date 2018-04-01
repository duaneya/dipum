clc,clear,close all;
f = imread('Fig0622(a).tif');
fR = f(:,:,1);
fG = f(:,:,2);
fB = f(:,:,3);
figure
subplot(141),imshow(f)
subplot(142),imshow(fR)
subplot(143),imshow(fG)
subplot(144),imshow(fB)
w = fspecial('average', 25);
fR_filtered = imfilter(fR, w, 'replicate');
fG_filtered = imfilter(fG, w, 'replicate');
fB_filtered = imfilter(fB, w, 'replicate');
f_filtered = cat(3,fR_filtered,fG_filtered,fB_filtered);
h = rgb2hsi(f);
H = h(:,:,1);
S = h(:,:,2);
I = h(:,:,3);
figure
subplot(131),imshow(H)
subplot(132),imshow(S)
subplot(133),imshow(I)
I_filtered = imfilter(I,w,'replicate');
h = cat(3,H,S,I_filtered);
f = hsi2rgb(h);
figure
subplot(131),imshow(f_filtered)
subplot(132),imshow(f)
H_filtered = imfilter(H,w,'replicate');
S_filtered = imfilter(S,w,'replicate');
h = cat(3,H_filtered,S_filtered,I_filtered);
f = hsi2rgb(h);
subplot(133),imshow(f)