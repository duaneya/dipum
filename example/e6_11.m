clc,clear,close all;
cv = tifs2cv('shuttle.tif', 16, [8 8]);
imratio('/home/duan/matlab_workspace/DIP/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Ed_CH08_Images/shuttle.tif',cv)
figure
subplot(131),showmo(cv,2);
tic; cv2 = tifs2cv('/home/duan/matlab_workspace/DIP/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Ed_CH08_Images/shuttle.tif', 16, [8 8], 1); toc
tic; cv2tifs(cv2, 'ss2.tif'); toc
imratio('/home/duan/matlab_workspace/DIP/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Ed_CH08_Images/shuttle.tif',...
    cv2)
compare(imread('/home/duan/matlab_workspace/DIP/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Ed_CH08_Images/shuttle.tif',16),...
    imread('ss2.tif',8))
compare(imread('/home/duan/matlab_workspace/DIP/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Original_Book_Images/DIPUM2E_International_Ed_CH08_Images/shuttle.tif',16),...
    imread('ss2.tif',16))