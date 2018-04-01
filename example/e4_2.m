clc,clear,close all;
r1 = imnoise2('gaussian',100000,1);
r2 = imnoise2('uniform',100000,1);
r3 = imnoise2('lognormal',100000,1);
r4 = imnoise2('rayleigh',100000,1);
r5 = imnoise2('exponential',100000,1);
r6 = imnoise2('erlang',100000,1);
bins=50
figure
subplot(231),hist(r1,bins)
subplot(232),hist(r2,bins)
subplot(233),hist(r3,bins)
subplot(234),hist(r4,bins)
subplot(235),hist(r5,bins)
subplot(236),hist(r6,bins)