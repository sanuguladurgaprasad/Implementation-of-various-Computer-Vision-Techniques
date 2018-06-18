function p = perimeter(I,x,y)
    [row,col]=size(I);
    stX=0;stY=0;secX=0;secY=0;
    for i=x:col
        if(I(y,i)==0)
           stX = i;
           stY = y;
           break;
        end
    end
    curX=stX;
    curY=stY;
    dir=7;
    p=0;
    while 1
        p=p+1;
        if curX+1>col
            n0=1;
        else
            n0=I(curY,curX+1);
        end
        
        if curX+1>col || curY-1<1
            n1=1;
        else
            n1=I(curY-1,curX+1);
        end
        
        if curY-1<1
            n2=1;
        else
            n2=I(curY-1,curX);
        end
        
        if curX-1<1 || curY-1<1
            n3=1;
        else
            n3=I(curY-1,curX-1);
        end
        
        if curX-1<1
            n4=1;
        else
            n4=I(curY,curX-1);
        end
        
        if curY+1>row || curX-1<1
            n5=1;
        else
            n5=I(curY+1,curX-1);
        end
        
        if curY+1>row
            n6=1;
        else
            n6=I(curY+1,curX);
        end
        
        if curX+1>col || curY+1>row
            n7=1;
        else
            n7=I(curY+1,curX+1);
        end
        %direction updation
        arr = [n0 n1 n2 n3 n4 n5 n6 n7];
        if mod(dir,2)==0
            dir=mod(dir+7,8); 
        else
            dir=mod(dir+6,8);
        end
        st=dir;
        check=0;
        for i=1:8
            if(arr(st+1)==0)
                check=1;
                break;
            else
                st = mod(st+1,8);
            end
        end
        if check==0
            break;
        end
        %next boundary pixel
        prevX=curX;
        prevY=curY;
        if st==0
            curX=curX+1;
        elseif st==1
            curX=curX+1;
            curY=curY-1;
        elseif st==2
            curY=curY-1;
        elseif st==3
            curX=curX-1;
            curY=curY-1;
        elseif st==4
            curX=curX-1;
        elseif st==5
            curX=curX-1;
            curY=curY+1;
        elseif st==6
            curY=curY+1;
        else
            curX=curX+1;
            curY=curY+1;
        end
        if p==1
            secX=curX;secY=curY;
        elseif prevX==stX && prevY==stY && curX==secX && curY == secY
            p=p-1;
            break;
        end
        dir=st;
    end
    
end