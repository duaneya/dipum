clc,clear,close all;
g1 = zeros(600, 600);
g1(100:500, 250:350) = 1;
g2 = phantom('Modified Shepp-Logan',600);
D = 1.5*hypot(size(g1, 1), size(g1,2))/2;
B1_line = fanbeam(g1, D, 'FanSensorGeometry','line','FanSensorSpacing',1,'FanRotationIncrement',0.5);
B1_line = flipud(B1_line');
B2_line = fanbeam(g2, D, 'FanSensorGeometry','line','FanSensorSpacing',1,'FanRotationIncrement',0.5);
B2_line = flipud(B2_line');
B1_arc = fanbeam(g1, D, 'FanSensorGeometry','arc','FanSensorSpacing',.08,'FanRotationIncrement',0.5);
B2_arc = fanbeam(g2, D, 'FanSensorGeometry','arc','FanSensorSpacing',.08,'FanRotationIncrement',0.5);
figure
subplot(221),imshow(B1_line, [])
subplot(222),imshow(B2_line, [])
subplot(223),imshow(flipud(B1_arc'), [])
subplot(224),imshow(flipud(B2_arc'), [])