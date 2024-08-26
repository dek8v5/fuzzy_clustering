clear;
clc;
% close;
imIn = imread('ballons.jpeg');

[imOut,C,U,iter] = My_FLICM(imIn, 11);

%based on number of cluster
U1 = U(:,:,1);
U2 = U(:,:,2);
U3 = U(:,:,3);
U4 = U(:,:,4);
U5 = U(:,:,5);
U6 = U(:,:,6);
U7 = U(:,:,7);
U8 = U(:,:,8);
U9 = U(:,:,9);
U10 = U(:,:,10);
U11 = U(:,:,11);




figure,
imshow(imIn, [0 255]) 
title('FLICM original');

figure,
imshow(uint8(imOut),[0 255])
title('FLICM segmented');