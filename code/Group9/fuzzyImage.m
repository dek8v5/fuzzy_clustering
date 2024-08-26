
function fuzzyIm( imOut, U, label, stringType)
%fuzzyIm  Converts a crisp segmented image to a fuzzy representation
%using each pixels cluster membership value and tinting.
%Pixels become lighter the less sure it is that they belong to their
%assigned cluster.

%needs ImOut, U, label
%imOut is an array HxWx3 that makes up a true color rgb image
%label is a single column with all membership labels
%U is a reshaped array with membership values for every pixel over a number of channels equal to the number of clusters

%uses size of image array to get number of rows and columns
[row,col,channel] = size(imOut);

%cycles through every pixel in all rows and columns
for Col=1:col
    for Row=1:row
	
		%gets the red green and blue value for a pixel
        R_pixel=imOut(Row,Col,1);
		G_pixel=imOut(Row,Col,2);
		B_pixel=imOut(Row,Col,3);
		
		%uses the columns of labels to reshape an array
		%matches labels to pixel position
        L = reshape(label,row,col);

		%gets membership value for pixel according to label
        mem = 1-U(Row,Col,L(Row,Col));
        
		%changes rgb value for pixel using a 1:2:3 ratio to tint it
		%larger adjustments make pixel lighter
        R_pixel = R_pixel + (mem * .5 * (255 - R_pixel)); 
        G_pixel = G_pixel + (mem * 1 * (255 - G_pixel)); 
        B_pixel = B_pixel + (mem * 1.5 * (255 - B_pixel)); 

		%rebuilds image using tinted pixels
        imFuz(Row,Col,1)=R_pixel;
        imFuz(Row,Col,2)=G_pixel;
        imFuz(Row,Col,3)=B_pixel;
        
    end
end

%shows the fuzzy representation image
figure,
imshow(uint8(imFuz),[0 255]), 
title(stringType);