clc,clear,close all;
g = phantom('Modified Shepp-Logan', 600);
D = 1.5*hypot(size(g, 1), size(g, 2))/2;
B1 = fanbeam(g, D);
f1 = ifanbeam(B1, D);
B2 = fanbeam(g, D, 'FanRotationIncrement', 0.5, 'FanSensorSpacing', 0.5);
f2 = ifanbeam(B2, D, 'FanRotationIncrement', 0.5, 'FanSensorSpacing', 0.5, 'Filter', 'Hamming');
B3 = fanbeam(g, D, 'FanRotationIncrement', 0.5, 'FanSensorSpacing', 0.5);
f3 = ifanbeam(B3, D, 'FanRotationIncrement', 0.5, 'FanSensorSpacing', 0.5, 'Filter', 'Hamming');
figure
subplot(131),imshow(f1, [])
subplot(132),imshow(f2, [])
subplot(133),imshow(f3, [])