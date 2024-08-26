function [ imOut, model, anormaly] = SPLI1M(dataset)
%%hyperparameter initialization

% number of data
n_of_data = size(dataset, 1);

[row, col, channel] = size(dataset);

%number of cluster, prefer big number first, it will stop when no dense
cluster=100;

%fuzzifier
m=1.5;

%threshold
epsilon=0.01;

%eta
eta=ones(1,cluster)*3.5;

%degree of membership
degree_membership_all=[];

cluster_center_all=[]; % cluster matrix collection
cov_max=[]; % covariance maxtrixs
point_num=[]; % each cluster points number
label=zeros(1,n_of_data);
U_count=zeros(1,cluster);
stop_count=0;
stop_code=0; % symbol to stop searching for new clusters
seed=2018; % random seed number

%% Keep searching for clusters until all clusters are found
for iter_c=1:cluster
    %-------------------------loop 2---------------------------------------
    while(1)
    % propabilities to choose cluster center
    seed=seed+1;
    selected_v = random_select(dataset, iter_c, degree_membership_all, seed);
    v(iter_c, :) = selected_v;

    %% ---------------------------loop 1 < P1M >------------------
    while(1)
        % compute d
        for i=1:n_of_data
            d(iter_c,i)=pdist2(dataset(i,:),v(iter_c,:))^2;
        end

        % compute u(v,X)
        for i=1:n_of_data
           u(iter_c,i)=1/(1+(d(iter_c,i)/eta(iter_c))^(1/(m-1)));
        end

        % compute v(u,X) / for 2 dimensions
        v_up=zeros(1,2);
        v_down=0;
        for i=1:n_of_data
            v_up(1,:)=v_up(1,:)+u(iter_c,i)^m*dataset(i,:);
            v_down=v_down+u(iter_c,i)^m;
        end
        v_new(iter_c,:)=v_up(1,:)/v_down;
        v_diff=pdist2(v(iter_c,:), v_new(iter_c,:))^2;
        v(iter_c,:)=v_new(iter_c,:);

        % if cluster center doesn`t move, break the while
        if v_diff<epsilon^2
            break;
        end
    end
    
    %% ----------------------------loop 1 < P1M > end-------------------

    % termination calculation
    stop_count=stop_count+1;
    for i=1:n_of_data
        if iter_c>1 && max(degree_membership_all(:,i))>0.5
            U_count(iter_c)=U_count(iter_c)+1;
        end
    end
    
    % if no more clusters found, terminate the program
    if stop_count>n_of_data*0.8-U_count(iter_c)
        stop_code=1;
        break;
    end
    
    % remove the coincident cluster center
    vw=zeros(1,iter_c-1);
    if iter_c>1
        for j=1:iter_c-1
           vw(j)=pdist2(v(iter_c,:),cluster_center_all(j,:))^2;
        end
        vw_min=min(vw);
        if vw_min>(sum(eta(1:iter_c))/iter_c)^2  % threshold
            break;
        end
    else
        break;
    end
    
    U_count(iter_c)=0;
    end
    %-----------------------------loop 2 end-------------------------------
    if stop_code == 1
        stop_code=0;
        break;
    end
    degree_membership_all=[degree_membership_all;u(iter_c,:)];
    cluster_center_all=[cluster_center_all;v(iter_c,:)];
    points=[];
    stop_count=0;
    for s=1:n_of_data
        if(u(iter_c,s)>0.05)
            points=[points;dataset(s,:)];
            label(s)=iter_c;
        end
    end
    point_num=[point_num,size(points,1)];
    cov_tmp=cov(points);
    cov_max=cat(3,cov_max,cov_tmp);
end

mean=cluster_center_all;
c_num=size(mean,1);

anormaly=[];
for i=1:n_of_data
     u_max=max(degree_membership_all(:,i));
     if(u_max<0.1)
         anormaly=[anormaly; dataset(i,:)];
     end
end
% % plot outliers
% if(size(anormaly) > 0)
%     figure(1);plot(anormaly(:,1), anormaly(:,2),'.r', 'MarkerSize', 10); hold on;
% end


% [~, label] = max(degree_membership_all', [], 2);

% imOut = reshape(cluster_center_all(label, :), row, col, channel);

model.mean=mean;
model.cov_max=cov_max;
model.c_num=c_num;
model.point_num=point_num;
model.label=label;

end

