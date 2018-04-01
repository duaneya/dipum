clc,clear,close all;
f = imread('Fig1023(a).tif');
g1 = splitmerge(f,32,@predicate);
g2 = splitmerge(f,16,@predicate);
g3 = splitmerge(f,8,@predicate);
g4 = splitmerge(f,4,@predicate);
g5 = splitmerge(f,2,@predicate);
figure
subplot(231),imshow(f)
subplot(232),imshow(g1)
subplot(233),imshow(g2)
subplot(234),imshow(g3)
subplot(235),imshow(g4)
subplot(236),imshow(g5)
function flag = predicate(region)
       sd = std2(region);
       m = mean2(region);
       flag = (sd > 10) & (m > 0) & (m < 125);
end