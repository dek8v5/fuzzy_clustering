clear;
clc;

imIn = imread('ballons.jpeg');
imIn= imnoise(imIn, 'salt & pepper', 0.001);

imIn = double(imIn);

[row, col, channel] = size(imIn);

imIn = reshape(imIn, row*col*channel, 1);

[center, U] = fcm(imIn,11);

[~, label] = max(U, [], 1);

imOut = reshape(center(label,:), row, col, channel);

figure,
imshow(uint8(imOut), [0 255]);
title('fcm C=11')

% fuzzyIm(imOut, U, label');
% 
% for i=1:size(U,1)
%     U(:,:,i) = reshape(U(i,:), row, col, channnel);
% end


% [~, label] = max(P, [], 2);
% 
% imOut = reshape(C(label, :), row, col, channel);