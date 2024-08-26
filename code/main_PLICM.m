clear;
clc;
close all;

imIn = imread('ballons.jpeg');

%imIn = imnoise(imIn, 'salt & pepper', 0.01);

[imOut,C,U,iter] = My_PLICM(imIn, 11, 2, 17);

figure,
imshow(uint8(imIn), [0 255]) 
title('PLICM original');

figure,
imshow(uint8(imOut),[0 255]) 
title('PLICM segmented');