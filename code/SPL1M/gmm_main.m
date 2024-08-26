% Sequential Possibilistic One-Means Clustering 
% For streaming clustering to detect outliers and trajectory trends
% In Gaussian Mixture Model 
% @author: Wenlong Wu
% @date: 08/29/2018
% @email: ww6p9@mail.missouri.edu
% @University of Missouri-Columbia

close all;
clear;clc;

% import data
addpath(genpath(pwd));
in = imread('REDDIT.jpg');
data = rgb2gray(in);
data = double(data);
% use 1/5 of data to find prototype, use the rest as streaming data
% [h, w, channel] = size(data);
figure,
imshow(uint8(data),[0, 255]);
title('Original');
% data = reshape(data, h*w, channel);
%% Use current data to find prototype
[model, anormaly] = sp1m(data);
