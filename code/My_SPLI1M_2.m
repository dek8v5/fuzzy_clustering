function [imOut,V,U,iter] = My_SPLI1M_2( img, cNum, m, winSize, maxIter, thrE )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

img = double(img);
[row, col, channel] = size(img);

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
    m = 2;
end

if nargin < 2
    cNum = 2;
end

rng(1)

totalPixel = row*col;

data = reshape(img, row*col, channel);

U = zeros(row, col);
V = [];

Uall = [];
Vall = [];


h_pad = round((winSize-1)/2);
w_pad = round((winSize-1)/2);

%initialize degree of membership with padding
U_padded = ones(row+2*h_pad, col+2*w_pad);
%initialize the 
DD_padded = zeros(row+2*h_pad, col+2*w_pad);
C_prev = inf;
C_temp = [];

seed = 2018;

GG = zeros(row, col);

U_count=zeros(1,cNum);
stop_count=0;
stop_code=0;

for iter= 1:cNum
    
    disp(iter);
    
    eta=ones(1, iter)*3.5;
    
    while(1)
        disp('1st while');
    % propabilities to choose cluster center
    seed=seed+1;
    selected_v = random_select(data, iter, U, seed);
    v(iter, :) = selected_v;
    
    while true

       %calculate the distance from data x to cluster center 
       dist(:, iter)=pdist2(data,v(iter,:));      
       
       %reshape 
       DD_padded(1+h_pad:row+h_pad, 1+w_pad:col+w_pad, :) = reshape(dist(:, iter), row, col, 1);

       U_padded(1+h_pad:row+h_pad, 1+w_pad:col+w_pad, :) = U;


       %calculate Fuzzy factor G

       for ii = -h_pad:h_pad
           for jj = -w_pad:w_pad
               if ii~=0&&jj~=0
                   GG = GG + 1/(1+ii*ii+jj*jj)*(1-U_padded(1+h_pad+ii:row+h_pad+ii, 1+w_pad+jj:col+w_pad+jj, :)).^m.*DD_padded(1+h_pad+ii:row+h_pad+ii, 1+w_pad+jj:col+w_pad+jj, :);
               end
           end
       end

       G = reshape(GG, row*col, 1);

       rd = dist(:, iter) + G;

       % update u degree of membership
       U = 1./(ones(1, iter)+(rd./eta).^(1/(m-1)));
       
       %update v
       t = U.^m;
       V = (t'*data)./(sum(t)'*ones(1, channel));
      
       %disortion
       J_cur = (sum(sum((U.^m).*dist(:, iter)+G))/totalPixel)+ (sum(eta)*sum((ones(1, iter) - U).^m));
       
       U = reshape(U(:, iter), row, col);
       
       disp(norm(V-C_prev, 'fro'));

        if norm(V-C_prev, 'fro') < thrE
            break;
        end

        C_prev = V;

    end
    
   
    
    if iter>1
        for i=1:iter-1
            v_norm(i) = norm(Vall(i,:)-V, 'fro');
        end
        if min(v_norm)>= 2*eta
         break;
        end
    else
        break;
    end
    
    end
    
    Uall = [Uall, U];
    Vall = [Vall; V];


end

[~, label] = max(Uall, [], 3);

imOut = reshape(V(label, :), row, col, channel);
end
   


