function objectRecog(img)
    set(0,'RecursionLimit',15000)
    I = imread(img);
    [row,col]=size(I);
    intensity = zeros(256,1);
    for i=1:row
        for j=1:col
            intensity(I(i,j)+1) = intensity(I(i,j)+1) + 1; 
        end
    end
    bar(intensity),title('Histogram of Image');
    %Thresholding
    level = otsuMethod(intensity);
    I(find(I(:)<level))=0;
    I(find(I(:)>=level))=1;
    I=mat2gray(I);
    figure;
    imshow(I),title('Thresholded Image');
    orgImg = I;
    
    %Floodfilling
    %Calculate MBR, area, centroid during this process
    regions = {};
    k=1;
    for i= 1:row
        for j=1:col
            if I(i,j)==0
                k=1+k;
                [I,minX,maxX,minY,maxY,area,centX,centY]=floodFill(I,i,j,row,col,k,col,0,row,0,0,0,0);
                centX = centX/area;
                centY = centY/area;
                tempImage = ones(row,col);
                tempImage(find(I(:)==k))=0;
                regions{k-1,1}=tempImage;
                regions{k-1,2} = minX;
                regions{k-1,3} = maxX;
                regions{k-1,4} = minY;
                regions{k-1,5} = maxY;
                regions{k-1,6} = area;
                regions{k-1,7} = centX;
                regions{k-1,8} = centY;
            end
        end
    end
    fileID = fopen('output.txt','w');
    %display only the relevant connected components
    for t=3:k-1
        regions{t,9} = perimeter(mat2gray(regions{t,1}),regions{t,2},regions{t,4});
        tmp = ones(row+2,col+2);
        tmp(2:row+1,2:col+1) = mat2gray(regions{t,1});
        [regions{t,10},regions{t,11}] = holes(tmp(regions{t,4}:regions{t,5}+2,regions{t,2}:regions{t,3}+2));
        regions{t,12} = regions{t,9}^2/regions{t,6};
        imwrite(regions{t,1}, sprintf('REGION %d.png',t-2));
        %imshow(regions{t,1}),title(sprintf('REGION %d',t-2));
        fprintf(fileID,'REGION %d\n',t-2);
        fprintf(fileID,'MBR coordinates = (%d,%d) (%d,%d) (%d,%d) (%d,%d) \n',regions{t,4},...
            regions{t,2},regions{t,4},regions{t,3},regions{t,5},regions{t,3},regions{t,5},regions{t,2});
        fprintf(fileID,'Area = %d \ncentroidX = %d centroidY = %d \nPerimeter = %d \nElongation = %d \nNumber of Holes = %d\n',...
            regions{t,6},regions{t,7},regions{t,8},regions{t,9},regions{t,12},regions{t,10});
        fprintf(fileID,'Holes Area = %d ',regions{t,11});
        fprintf(fileID,'\n\n');
    end
    fclose(fileID);
    figure;
    imshow(orgImg);
    for t=3:k-1
        hold on;
        plot(regions{t,7},regions{t,8},'o','Color','r');
        plot([regions{t,2} regions{t,3} regions{t,3} regions{t,2} regions{t,2}],...
            [regions{t,4} regions{t,4} regions{t,5} regions{t,5} regions{t,4}],'LineWidth',3,'Color','r');
    end
end