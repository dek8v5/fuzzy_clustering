function [imOut,C,U,iter] = My_PLICM( img, cNum, m, winSize, maxIter, thrE )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

img = double(img);
[row, col, channel] = size(img);

if nargin < 6
    thrE = 1.0e-2;
end

if nargin < 5
    maxIter = 200;
end

if nargin < 4
    winSize = 7;
end

if nargin < 3
    m = 2;
end

if nargin < 2
    cNum = 2;
end

rng(1)

%initialize C, U from FLICM
[imOut_FLICM,C,U,iter_FLICM] = My_FLICM(img, cNum, m, winSize, maxIter, thrE);

eta=ones(1,cNum)*3.5;

iter = 0;

totalPixel = row*col;

X = reshape(img, row*col, channel);

P = reshape(U, row*col, cNum);

h_pad = round((winSize-1)/2);
w_pad = round((winSize-1)/2);

%initialize degree of membership with padding
U_padded = ones(row+2*h_pad, col+2*w_pad, cNum);
%initialize the 
DD_padded = zeros(row+2*h_pad, col+2*w_pad, cNum);
C_prev = inf;
C_temp = [];

while true
   iter = iter + 1; 
   if iter>maxIter
       break;
   end
   
   %degree of membership*m m is parameter that can be pick from 1 to inf
   t = P.^m;
   
   %calculate cluster center
   C = (t'*X)./(sum(t)'*ones(1, channel));
   
   %calculate the distance from data x to cluster center 
   dist = sum(X.*X, 2)*ones(1, cNum) + (sum(C.*C, 2)*ones(1, totalPixel))'-(2*X*C');
   
   %reshape 
   DD_padded(1+h_pad:row+h_pad, 1+w_pad:col+w_pad, :) = reshape(dist, row, col, cNum);
   
   U_padded(1+h_pad:row+h_pad, 1+w_pad:col+w_pad, :) = U;
   
   
   %calculate Fuzzy factor G
   GG = zeros(row, col, cNum);
   for ii = -h_pad:h_pad
       for jj = -w_pad:w_pad
           if ii~=0&&jj~=0
               GG = GG + 1/(1+ii*ii+jj*jj)*(1-U_padded(1+h_pad+ii:row+h_pad+ii, 1+w_pad+jj:col+w_pad+jj, :)).^m.*DD_padded(1+h_pad+ii:row+h_pad+ii, 1+w_pad+jj:col+w_pad+jj, :);
           end
       end
   end
   
   G = reshape(GG, row*col, cNum);
    
   rd = dist + G;
   
   %degree of membership
   P = 1./(ones(1, cNum)+(rd./eta).^(1/(m-1)));
   
   U = reshape(P, row, col, cNum);
   
   %disortion
   J_cur = (sum(sum((P.^m).*dist+G))/totalPixel)+ (sum(eta)*sum((ones(1, cNum) - P).^m));
   
   C_temp = [C_temp C];
    
    if norm(C-C_prev, 'fro') < thrE
        break;
    end
    
    C_prev = C;
   
end

[~, label] = max(P, [], 2);

imOut = reshape(C(label, :), row, col, channel);

disp(iter);

end

