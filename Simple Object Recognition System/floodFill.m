function [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i,j,row,col,k,minX,maxX,minY,maxY,area,centX,centY)
    if(i>0 && i<=row && j>0 && j<=col && I(i,j)==0)
        I(i,j)=k;
        area = area + 1;
        centX = centX + j;
        centY = centY + i;
        if i<minY
            minY=i;
        end
        if i>maxY
            maxY=i;
        end
        if j<minX
            minX=j;
        end
        if j>maxX
            maxX=j;
        end
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i,j+1,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i-1,j+1,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i-1,j,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i-1,j-1,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i,j-1,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i+1,j-1,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i+1,j,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
        [I,minX,maxX,minY,maxY,area,centX,centY] = floodFill(I,i+1,j+1,row,col,k,minX,maxX,minY,maxY,area,centX,centY);
    end
end