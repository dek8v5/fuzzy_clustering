function [imOut,C,U,iter] = My_FLICM( img, cNum, m, winSize, maxIter, thrE )
if nargin < 6
    thrE = 1.0e-2;
end

if nargin < 5
    maxIter = 100;
end

if nargin < 4
    winSize = 3;
end

if nargin < 3
    m = 1.5;
end

if nargin < 2
    cNum = 2;
end

%color image transform to rgb

%cast image into double for calculation purpose
image = double(img);

%initialization
iter = 0;

[row,col,channel] = size(image);

totalPixel = row*col;

%initialize degree of membership matrix based on the image dimension
U = rand( row, col, cNum-1 )*(1/cNum);

%initialize degree members with it channels (channels = numCluster)
U(:,:,cNum) = 1 - sum(U,3);

%reshape the image with row = row*col and col=channel
X = reshape(image, row*col, channel);

%reshape the degree of membership with the same size as the reshaped imageX
P = reshape(U, row*col, cNum);

%padding height and weight for filter -> to maintain the size of the image
h_pad = round((winSize-1)/2);
w_pad = round((winSize-1)/2);

%initialize degree of membership with padding
U_padded = ones(row+2*h_pad, col+2*w_pad, cNum);
%initialize the 
DD_padded = zeros(row+2*h_pad, col+2*w_pad, cNum);
J_prev = inf; 
J = [];
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
   
   t2 = (1./rd).^(1/(m-1));
   
   P = t2./(sum(t2, 2)*ones(1, cNum));
   
   U = reshape(P, row, col, cNum);
   
   J_cur = sum(sum((P.^m).*dist+G))/totalPixel;
   
   J = [J J_cur];
   
   if norm(J_cur-J_prev, 'fro') < thrE
       break;
   end
   
   J_prev = J_cur;
   
end

[~, label] = max(P, [], 2);

imOut = reshape(C(label, :), row, col, channel);


