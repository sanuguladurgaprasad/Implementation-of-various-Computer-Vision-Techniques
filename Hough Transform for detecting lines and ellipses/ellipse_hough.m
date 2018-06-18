function ellipse_hough(img,Gdir,a,b,flag)
    [row,col] = size(img);
    %accumulator array for all four parameters
    accumulator = zeros(length(a),length(b),row,col);
    for y=1:row
        for x=1:col
            if img(y,x)==1
                for i=1:length(a)
                    for j=1:length(b)
                        %condition to find only horizontal or vertical ellipses
                        if (a(i)>=b(j) & flag==0) || (b(j)>=a(i) & flag==1)
                            %For all possible values of a and b find all the
                            %possible ellipse centers 
                            tempX = round(a(i)/sqrt(1+b(j)^2/(a(i)^2*tand(Gdir(y,x)-90)^2)));
                            tempY = round(b(j)/sqrt(1+(a(i)^2*tand(Gdir(y,x)-90)^2)/b(j)^2));
                            xx1 = x+tempX;
                            xx2 = x-tempX;
                            yy1 = y+tempY;
                            yy2 = y-tempY;
                            %Check out of bound conditions and increment
                            %the accumulator
                            if xx1<=col & yy1 <=row
                                accumulator(i,j,yy1,xx1) = accumulator(i,j,yy1,xx1) + 1;
                            end
                            if xx1<=col & yy2 >0
                                accumulator(i,j,yy2,xx1) = accumulator(i,j,yy2,xx1) + 1;
                            end
                            if xx2>0 & yy1 <=row
                                accumulator(i,j,yy1,xx2) = accumulator(i,j,yy1,xx2) + 1;
                            end
                            if xx2>0 & yy2>0
                                accumulator(i,j,yy2,xx2) = accumulator(i,j,yy2,xx2) + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    x=1:650;
    hold on;
    %Scale the accumulator array
    accumulator = mat2gray(accumulator,[min(accumulator(:)) max(accumulator(:))]);
    while 1
        [v, linIdx] = max(accumulator(:));
        %Get the peaks only above particular threshold
        if v<0.8
            break;
        end
        %Get indices of max element in accumulator array
        [idxC{1:ndims(accumulator)}] = ind2sub(size(accumulator),linIdx);
        idx = cell2mat(idxC);
        xInd = idx(4);
        yInd = idx(3);
        r1 = a(idx(1));
        r2 = b(idx(2));
        %Check out of bound conditions and zero the surrounding pixels
        if(idx(1)>1 && idx(2)>1)
            accumulator(idx(1)-1:idx(1)+1,idx(2)-1:idx(2)+1,yInd-10:yInd+10,xInd-10:xInd+10)=0;
        else
            accumulator(idx(1),idx(2),yInd-10:yInd+10,xInd-10:xInd+10)=0;
        end
        %Plot and print the parameters of only possible ellipses
        sprintf('x=%d, y=%d, a=%d, b=%d',xInd,yInd,r1,r2)
        y=zeros(1,length(x))-1;
        true = (1-((x-xInd).*(x-xInd))/r1^2);
        ind=1;
        for j = true
            if j>=0
               y(1,ind) = sqrt(j)*r2; 
            end
            ind = ind+1;
        end
        plot(x(find(y>=0)),yInd+y(find(y>=0)),'Color','r','LineWidth',2);
        plot(x(find(y>=0)),yInd-y(find(y>=0)),'Color','r','LineWidth',2);
    end
end
