disp('The parameters of the lines are:');
I=imread('line1.jpg');
%convert the original image to grayscale and take complement of it to
%thin the image
I=rgb2gray(I);
%plot the input image
subplot(121),imshow(I),title('Detected Lines');
I = imcomplement(I);
%Thresholding and skeletonization
I=imbinarize(I);
I = bwmorph(I,'skel',Inf);
%Find the gradient direction 
[Gmag,Gdir] = imgradient(I,'Sobel');
line_hough(I);