clc,clear,close all;
f = imread('Fig0810(a).tif');
q = quantize(f, 4, 'igs');
qs = double(q) / 16;
e = mat2lpc(qs);
c = mat2huff(e);
imratio(f, c)
ne = huff2mat(c);
nqs = lpc2mat(ne);
nq = 16 * nqs;
compare(q, nq)
compare(f, nq)