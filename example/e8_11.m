clc,clear,close all;
f2 = imread('Fig1124(b).tif');
G2 = graycomatrix(f2, 'NumLevels', 256);
G2n = G2/sum(G2(:));
stats2 = graycoprops(G2, 'all');
maxProbability2 = max(G2n(:));
contrast2 = stats2.Contrast;
corr2 = stats2.Correlation;
energy2 = stats2.Homogeneity;
hom2 = stats2.Homogeneity;
for I = 1:size(G2n, 1);
    sumcols(I) = sum(-G2n(I, 1:end).*log2(G2n(I, 1:end)...
        +eps));
end
entropy2 = sum(sumcols);
offsets = [zeros(50,1) (1:50)'];
G2 = graycomatrix(f2,'Offset',offsets);
stats2 = graycoprops(G2, 'Correlation');
figure
subplot(132),plot([stats2.Correlation]);
xlabel('Horizontal Offset')
ylabel('Correlation')

f1 = imread('Fig1124(a).tif');
G2 = graycomatrix(f1, 'NumLevels', 256);
G2n = G2/sum(G2(:));
stats2 = graycoprops(G2, 'all');
maxProbability2 = max(G2n(:));
contrast2 = stats2.Contrast;
corr2 = stats2.Correlation;
energy2 = stats2.Homogeneity;
hom2 = stats2.Homogeneity;
for I = 1:size(G2n, 1);
    sumcols(I) = sum(-G2n(I, 1:end).*log2(G2n(I, 1:end)...
        +eps));
end
entropy2 = sum(sumcols);
offsets = [zeros(50,1) (1:50)'];
G2 = graycomatrix(f1,'Offset',offsets);
stats2 = graycoprops(G2, 'Correlation');
subplot(131),plot([stats2.Correlation]);
xlabel('Horizontal Offset')
ylabel('Correlation')

f3 = imread('Fig1124(c).tif');
G2 = graycomatrix(f3, 'NumLevels', 256);
G2n = G2/sum(G2(:));
stats2 = graycoprops(G2, 'all');
maxProbability2 = max(G2n(:));
contrast2 = stats2.Contrast;
corr2 = stats2.Correlation;
energy2 = stats2.Homogeneity;
hom2 = stats2.Homogeneity;
for I = 1:size(G2n, 1);
    sumcols(I) = sum(-G2n(I, 1:end).*log2(G2n(I, 1:end)...
        +eps));
end
entropy2 = sum(sumcols);
offsets = [zeros(50,1) (1:50)'];
G2 = graycomatrix(f3,'Offset',offsets);
stats2 = graycoprops(G2, 'Correlation');
subplot(133),plot([stats2.Correlation]);
xlabel('Horizontal Offset')
ylabel('Correlation')

figure
subplot(311),imshow(f1)
subplot(312),imshow(f2)
subplot(313),imshow(f3)