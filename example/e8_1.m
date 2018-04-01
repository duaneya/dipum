clc,clear,close all;
f = [
 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
 0 1 1 1 1 1 1 1 1 1 1 1 1 0;
 0 1 1 1 1 1 1 1 1 1 1 1 1 0;
 0 1 1 0 0 0 0 0 0 0 0 1 1 0;
 0 1 1 0 1 1 1 1 1 1 0 1 1 0;
 0 1 1 0 1 1 1 1 1 1 0 1 1 0;
 0 1 1 0 1 1 0 0 1 1 0 1 1 0;
 0 1 1 0 1 1 0 0 1 1 0 1 1 0;
 0 1 1 0 1 1 1 1 1 1 0 1 1 0;
 0 1 1 0 1 1 1 1 1 1 0 1 1 0;
 0 1 1 0 0 0 0 0 0 0 0 1 1 0;
 0 1 1 1 1 1 1 1 1 1 1 1 1 0;
 0 1 1 1 1 1 1 1 1 1 1 1 1 0;
 0 0 0 0 0 0 0 0 0 0 0 0 0 0
];
B = bwboundaries(f, 'noholes');
numel(B)
b = cat(1, B{:});
[M, N] = size(f);
imgae = bound2im(b, M, N)
[B, L, NR, A] = bwboundaries(f);
numel(B)
numel(B) - NR
bR = cat(1, B{1:2}, B{4});
imageBoundaries = bound2im(bR, M, N);
imageNumveredBoundaries = imageBoundaries.*L
bR = cat(1, B{:});
imageBoundaries = bound2im(bR, M, N);
imageNumberedBoundaries = imageBoundaries.*L
find(A(:,1))
find(A(1,:))
A
full(A)