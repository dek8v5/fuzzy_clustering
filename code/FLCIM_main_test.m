
clear;
clc;
close all;

cNum = 850;
% cNum = 16;
m = 2;
winSize = 3;
maxIter = 900;
% thrE    = 0.001;
thrE    = 0.002;

load indianaPines.mat;
data = pixels';
data = normr(data);
label = reshape(Label,145,145);
label = label';
label = label(:);

% -- not get rid of backgroud pixel
% [H,W] = size( data(:,:,1) );
% U = rand( H, W, cNum-1 )*(1/cNum);
% U(:,:,cNum) = 1 - sum(U,3);
% % FLICM
% [U,iter] = FLICM_multiD( data, H, W, U, m, cNum, winSize, maxIter, thrE );

% initialize degree of membership
idxNon0 = find(label~=0);
U = rand( numel(idxNon0), cNum-1 )*(1/cNum);
U(:,cNum) = 1 - sum(U,2);

% -- get rid of backgroud pixel
[U,iter] = flicm_indiana( data, label, U, m, cNum, maxIter, thrE );

[~,class] = max(U,[],2);
drawlabel = zeros(145*145,1);
drawlabel(idxNon0) = class;
plotclass(drawlabel,145,145);