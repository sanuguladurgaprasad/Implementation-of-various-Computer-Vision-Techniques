function find_peaks(acc,row_len,maxrho)
    [min_val,min_pos] = max(acc(:));
    rho = 0;
    theta = 0;
    %Get maximum peak above certain threshold and zero the surrounding pixels
    while(min_val>0.4)
        row = mod(min_pos,row_len);
        col = ceil(min_pos/row_len);
        sprintf('rho=%d  theta=%d',row-maxrho-1,col-181)
        rho = [rho row-maxrho-1];
        theta = [theta col-181];
        %Following are the conditions that check out of bound conditions
        %while zeroing the neighboring pixels
        if row-8<1
            tr=1;
        else
            tr=row-8;
        end
        
        if row+8>row_len
            br=row_len;
        else
            br=row+8;
        end
        
        if col-8<1
            lc=1;
        else
            lc=col-8;
        end
        
        if col+8<1
            rc=1;
        else
            rc=col+8;
        end
        %Zeroing the surrounding pixels
        acc(tr:br,lc:rc) = 0;
        [min_val,min_pos] = max(acc(:));
    end
    %Plot the lines
    if length(rho)>1
        x=50:50:600;
        hold on;
        rho = rho(2:length(rho));
        theta = theta(2:length(theta));
        for i=1:length(rho)
           y = (rho(i)-x*cosd(theta(i)))/sind(theta(i));
           plot(x,y);
        end
    end
end