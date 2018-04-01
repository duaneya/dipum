clc,clear,close all;
f2 = uint8([2 3 4 2; 3 2 4 4; 2 2 1 2; 1 1 2 2])
whos('f2')
c = huffman(hist(double(f2(:)), 4))
h1f2 = c(f2(:))'
whos('h1f2')
h2f2 = char(h1f2)'
whos('h2f2')
h2f2 = h2f2(:);
h2f2(h2f2 == ' ') = [];
whos('h2f2')
h3f2 = mat2huff(f2)
whos('h3f2')
hcode = h3f2.code;
whos('hcode')
dec2bin(double(hcode))