function [imOut,C,U,iter] = My_SPLI1M( img, m, winSize, maxIter, thrE )
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
    cNum = 50;
end

img = double(img);
[row, col, channel] = size(img);

eta=ones(1,cNum)*3.5;

U=[]; 
V=[];

iter = 0;

totalPixel = row*col;

data = reshape(img, row*col, channel);

h_pad = round((winSize-1)/2);
w_pad = round((winSize-1)/2);

%initialize degree of membership with padding
u_padded = ones(row+2*h_pad, col+2*w_pad);

%initialize the distance
DD_padded = zeros(row+2*h_pad, col+2*w_pad);

C_prev = inf;
C_temp = [];

seed=2018;

stop_count=0;
stop_code=0;

for iter=1:cNum
    %-------------------------loop 2---------------------------------------
    while(1)
    % propabilities to choose cluster center
    seed=seed+1;
    selected_v = random_select(data, iter, U, seed);
    v = selected_v;
     %% ---------------------------loop 1 < P1M >------------------
        while(1)
            
            d(:,iter)=pdist2(data,v);
            
            u(iter,:)=1/(1+(d(iter,:)/eta(iter))^(1/(fzr-1)));
               
            v_up(1,:)=v_up(1,:)+u(iter,m)^fzr*data(m,:);
               v_down=v_down+u(iter,m)^fzr;
           
            v_new(1,:)=v_up(1,:)/v_down;
            v_diff=pdist2_copy(v(1,:), v_new(1,:))^2
            v(1,:)=v_new(1,:);
            % if cluster center doesn`t move, break the while
            if v_diff<epsilon
                break;
            end
            
   
        end 
        
        stop_count=stop_count+1;
        if iter>1 && max(Uall)>0.5
            U_count(iter)=U_count(iter)+1;
        end
    
    
end

end


