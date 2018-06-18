function extGrassFire(img)
    I = imread(img);
    I = rgb2gray(I);
    subplot(121),imshow(I);
    temp = ones(size(I,1)+2,size(I,2)+2);
    temp(2:size(I,1)+1,2:size(I,2)+1) = I;
    I=temp;
    [row,col] = size(I);
    I=I*255;
    for i=2:row-1
        for j=2:col-1
            if(I(i,j)~=0)
                I(i,j)=1+min([I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)]);
            else
                I(i,j)=0;
            end
        end
    end
 
    for i=row-1:-1:2
        for j=col-1:-1:2
            if(I(i,j)~=0)
                I(i,j)=1+min([I(i-1,j-1) I(i-1,j) I(i-1,j+1) I(i,j+1) I(i+1,j+1) I(i+1,j) I(i+1,j-1) I(i,j-1)]);
            else
                I(i,j)=0;
            end
        end
    end
    
    I=mat2gray(I(2:row-1,2:col-1));
    subplot(122),imshow(I);
end