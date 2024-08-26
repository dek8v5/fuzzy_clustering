% This program illustrates the Fuzzy c-means segmentation of an image. 
% This program converts an input image into two segments using Fuzzy k-means
% algorithm. The output is stored as "fuzzysegmented.jpg" in the current directory.
% This program can be generalised to get "n" segments from  an image
% by means of slightly modifying the given code.
clear
clc
close

img=imread('4ff152d76db095f75c664dd48e41e8c9953fd0e784535883916383165e28a08e.png');

%convert 3 channel images into grayscale
img = rgb2gray(img);

%remove noise in the image
img = imgaussfilt(img,2);

img=double(img);

%display the original image
figure(1)
subplot(1,2,1);
imshow(uint8(img))
title('original image');


[row,col]=size(img);
%duplicate IM into 2 channel
img_2channel=cat(3,img,img);


%some initialization 
center1=8;
center2=250;
ttFcm=0;

while(ttFcm<15)
    ttFcm=ttFcm+1;
    
    cluster1=repmat(center1,row,col);
    cluster2=repmat(center2,row,col);
    
    if ttFcm==1 
        test1=cluster1; 
        test2=cluster2;
    end
    c=cat(3,cluster1,cluster2);
    
    ree=repmat(0.000001,row,col);
    ree1=cat(3,ree,ree);
    
    distance=img_2channel-c;
    distance=distance.*distance+ree1;
    
    dm=1./distance;
    
    %calcuate degree of membership
    dm2channels=dm(:,:,1)+dm(:,:,2);
    distance1=distance(:,:,1).*dm2channels;
    degree_membership1=1./distance1;
    distance2=distance(:,:,2).*dm2channels;
    degree_membership2=1./distance2;
    
    %calculate the center of each cluster
    new_center1=sum(sum(degree_membership1.*degree_membership1.*img))/sum(sum(degree_membership1.*degree_membership1));
    new_center2=sum(sum(degree_membership2.*degree_membership2.*img))/sum(sum(degree_membership2.*degree_membership2));
   
    tmpMatrix=[abs(center1-new_center1)/center1,abs(center2-new_center2)/center2];
    pp=cat(3,degree_membership1,degree_membership2);
    
    for i=1:row
        for j=1:col
            if max(pp(i,j,:))==degree_membership1(i,j)
                IX2(i,j)=1;
           
            else
                IX2(i,j)=2;
            end
        end
    end
    %%%%%%%%%%%%%%%
   if max(tmpMatrix)<0.0001
         break;
  else
         center1=new_center1;
         center2=new_center2;
        
  end
 for i=1:row
       for j=1:col
            if IX2(i,j)==2
            IMMM(i,j)=254;
                 else
            IMMM(i,j)=8;
       end
    end
end
%%%%%%%%%%%%%%%%%%
% figure(2);
% imshow(uint8(IMMM));
tostore=(IMMM==254);
imwrite(tostore,'fuzzysegmented.png');

end
for i=1:row
    for j=1:col
         if IX2(i,j)==2
            IMMM(i,j)=200;
             else
             IMMM(i,j)=1;
    end
  end
end 
%%%%%%%%%%%%%%%%%%

IMMM=uint8(IMMM);
subplot(2,1,2);
imshow(IMMM);
title('Final segmented image')
disp('The final cluster centers are');
new_center1
new_center2