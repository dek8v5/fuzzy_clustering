clear;
clc;

imIn = imread('ballons.jpeg');

[imOut,C,U,iter] = My_SPLI1M_2(imIn);

figure,
imshow(uint8(imIn), [0 255]) 
title('PLICM original');

figure,
imshow(uint8(imOut),[0 255]) 
title('PLICM segmented');