clc,clear,close all;
f = imread('Fig0604(a).tif');
fp = padarray(f, [40 40], 255, 'both');
fp = padarray(fp, [4 4], 230, 'both');
figure
subplot(121),imshow(fp)
p_srgb = iccread('sRGB.icm');
p_snap = iccread('SNAP2007.icc');
cform1 = makecform('icc', p_srgb, p_snap);
fp_newsprint = applycform(fp, cform1);
cform2 = makecform('icc', p_snap, p_srgb,...
    'SourceRenderingIntent', 'AbsoluteColorimetric',...
    'DestRenderingIntent', 'AbsoluteColorimetric');
fp_proof = applycform(fp_newsprint, cform2);
subplot(122),imshow(fp_proof)