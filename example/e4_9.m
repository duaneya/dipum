clc,clear,close all;
g1 = zeros(600, 600);
g1(100:500, 250:350) = 1;
g2 = phantom('Modified Shepp-Logan', 600);
figure
subplot(221),imshow(g1, [])
subplot(223),imshow(g2, [])
theta = 0:0.5:179.5;
[R1, xp1] = radon(g1, theta);
[R2, xp2] = radon(g2, theta);
R1 = flipud(R1');
R2 = flipud(R2');
subplot(222),imshow(R1, [], 'XData', xp1([1 end]), 'YData', [179.5 0])
axis xy
axis on
xlabel('\rho'),ylabel('\theta')
subplot(224),imshow(R2, [], 'XData', xp2([1 end]), 'YData', [179.5 0])
axis xy
axis on
xlabel('\rho'),ylabel('\theta')