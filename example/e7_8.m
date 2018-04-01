clc,clear,close all;
f = imread('Fig1014(a).tif');
figure
subplot(221),imshow(f)
subplot(222),imhist(f)
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
f2 = im2bw(f, T/255);
g = im2bw(f2,T/255);
subplot(223),imshow(g)
[T, SM] = graythresh(f);
g = im2bw(f,T);
subplot(224),imshow(g)