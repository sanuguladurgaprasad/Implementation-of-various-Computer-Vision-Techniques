function med(filter,img)
f=filter-1;
I=imread(img);
I=rgb2gray(I);
I=imnoise(I,'salt & pepper',0.02);
[m,n] = size(I);
ipImg = zeros(m+f,n+f);
ipImg(f/2+1:m+f/2,f/2+1:n+f/2)=I;
opImg = zeros(m,n);

for i=f/2+1:m+f/2
    for j=f/2+1:n+f/2
        temp=zeros(1,filter*filter);
        for k=-f/2:f/2
            for l=-f/2:f/2
                temp(filter*(k+f/2)+l+f/2+1)=ipImg(i+k,j+l);
            end
        end
        temp=sort(temp);
        opImg(i-f/2,j-f/2)=temp(1,floor(filter*filter/2)+1);
    end
end
opImg=uint8(opImg);
figure(1);
set(gcf,'Position',get(0,'Screensize'));
subplot(121),imshow(I),title('Original Image');
subplot(122),imshow(opImg),title(sprintf('New image with %dX%d median filtering',filter,filter));