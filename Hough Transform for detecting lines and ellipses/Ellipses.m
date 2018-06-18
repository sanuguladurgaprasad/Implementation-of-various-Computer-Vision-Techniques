disp('The parameters of the ellipses are:');
I=imread('ellipse1.jpg');
%convert the original image to grayscale
I=rgb2gray(I);
%Plot the original image
subplot(121),imshow(I),title('Detected Ellipses');
%Find the edges using Sobel operator
edgeI = edge(I,'Sobel');
%Find the gradient direction
[Gmag,Gdir] = imgradient(I,'Sobel');
%Choose the values of a and b based on input image
a = 10:1:160;
b = 10:1:80;
%Call the hough transform to detect horizontal ellipses
ellipse_hough(edgeI,Gdir,a,b,0);
%Uncomment the following line to detect vertical ellipses
%ellipse_hough(edgeI,Gdir,b,a,1);