clc,clear,close all;
C = [0 64; 0 128; 32 32; 64 0; 128 0; -32 32];
[r, ~, S] = imnoise3(512, 512, C);
figure
subplot(321),imshow(S, [])
subplot(322),imshow(r, [])
C = [0 32; 0 64; 16 16; 32 0; 64 0; -16 16];
[r, ~, S] = imnoise3(512, 512, C);
subplot(323),imshow(S, [])
subplot(324),imshow(r, [])
C = [6 32; -2 2];
[r, ~, ~] = imnoise3(512, 512, C);
subplot(325),imshow(r, [])
A = [1 5];
[r, ~, ~] = imnoise3(512, 512, C, A);
subplot(326),imshow(r, [])