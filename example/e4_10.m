clc,clear,close all;
g1 = zeros(600, 600);
g1(100:500, 250:350) = 1;
g2 = phantom('Modified Shepp-Logan', 600);
theta = 0:0.5:179.5;
R1 = radon(g1, theta);
R2 = radon(g2, theta);
f1 = iradon(R1, theta, 'none');
f2 = iradon(R2, theta, 'none');
f1_ram = iradon(R1, theta);
f2_ram = iradon(R2, theta);
f1_hamm = iradon(R1, theta, 'Hamming');
f2_hamm = iradon(R2, theta, 'Hamming');
f1_near = iradon(R1, theta, 'nearest');
f1_lin = iradon(R1, theta, 'linear');
f1_cub = iradon(R1, theta, 'cubic');
x = [400 400];
y = [400 500];
figure
subplot(241),imshow(g1, [])
subplot(242),imshow(g2, [])
subplot(243),imshow(f1, [])
subplot(244),imshow(f2, [])
subplot(245),imshow(f1_ram, [])
subplot(246),imshow(f2_ram, [])
subplot(247),imshow(f1_hamm, [])
subplot(248),imshow(f2_hamm, [])
figure
subplot(321),imshow(f1_near, [])
subplot(322),improfile(f1_near,x,y,'nearest')
subplot(323),imshow(f1_lin, [])
subplot(324),improfile(f1_lin,x,y,'bilinear')
subplot(325),imshow(f1_cub, [])
subplot(326),improfile(f1_cub,x,y,'bicubic')