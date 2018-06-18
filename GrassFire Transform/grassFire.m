function grassFire(img)
    I = imread(img);
    I = rgb2gray(I);
    subplot(121),imshow(I);
    [row,col] = size(I);
    
    for i=1:row
        for j=1:col
            if(I(i,j)==0) && i>1 && j>1 && j<col
                I(i,j)=1+min([I(i-1,j) I(i-1,j-1) I(i,j-1) I(i-1,j+1)]);
            else
                I(i,j)=0;
            end
        end
    end
    
    for i=row:-1:1
        for j=col:-1:1
            if(I(i,j)>0) && i<row && j<col && j>1
                I(i,j)=min(I(i,j),1+min([I(i+1,j) I(i+1,j+1) I(i+1,j-1) I(i,j+1)]));
            else
                I(i,j)=0;
            end
        end
    end
  
    I=mat2gray(I);
    subplot(122),imshow(I);
end