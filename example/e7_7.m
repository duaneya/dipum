clc,clear,close all;
f = imread('Fig1013(a).tif');
count = 0;
T = mean2(f);
done = false;
while ~done
    count = count +1;
    g = f > T;
    Tnext = 0.5*(mean(f(g)) + mean(f(~g)));
    done = abs(T - Tnext) < 0.5;
    T = Tnext;
end
count
T
g = im2bw(f, T/255);
subplot(131),imshow(f)
subplot(132),imhist(f)
subplot(133),imshow(g)