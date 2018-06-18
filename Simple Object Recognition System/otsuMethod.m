function [level] = otsuMethod(intensities)
    wb=0;
    mb=0;   
    wf=0;
    mf=0;
    v=0;
    level=0;
    min=10^6;
    dotProd = dot((0:255),intensities);
    sum1 = sum(intensities);
    for i=1:256
        vf=0;
        vb=0;
        mb = wb*mb+(i-1)*intensities(i);
        wb = (wb+intensities(i));
        mb=mb/wb;
        for j=1:i
            vb = vb + (j-1-mb)^2*intensities(j);
        end
        vb = vb/wb;
        wf = sum1-wb;
        if (wb == 0 || wf == 0)
            continue;
        end
        mf = (dotProd-mb*wb)/wf;
        for j=i+1:256
            vf = vf + (j-mf-1)^2*intensities(j);
        end
        vf = vf/wf;
        v=(wb*vb+wf*vf)/dotProd;

        if v<min
            level=i;
            min=v;
        end
    end
end