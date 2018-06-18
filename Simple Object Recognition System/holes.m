function [numHoles, areasOfHoles] = holes(I)
    areasOfHoles = [];
    numHoles=0;
    [row,col]=size(I);
    for i=1:row
        for j=1:col
            if(I(i,j)==1)
                [I,area]=dfsHoles(I,i,j,row,col,0);
                numHoles=numHoles+1;
                areasOfHoles = [areasOfHoles area];
            end
        end
    end
    numHoles = numHoles-1;
    if length(areasOfHoles)>1
        areasOfHoles = areasOfHoles(2:length(areasOfHoles));
    else
        areasOfHoles=[];
    end
end

function [I,area] = dfsHoles(I,i,j,row,col,area)
    if(i>0 && i<=row && j>0 && j<=col && I(i,j)==1)
        I(i,j)=0;
        area=area+1;
        [I,area] = dfsHoles(I,i-1,j,row,col,area);
        [I,area] = dfsHoles(I,i,j+1,row,col,area);
        [I,area] = dfsHoles(I,i+1,j,row,col,area);
        [I,area] = dfsHoles(I,i,j-1,row,col,area);
    end
end