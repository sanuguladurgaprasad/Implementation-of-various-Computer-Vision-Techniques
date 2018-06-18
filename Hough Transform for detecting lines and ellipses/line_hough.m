function line_hough(img)
    [row,col] = size(img);
    maxrho = floor(sqrt(row^2 + col^2));
    %store all the possible values of rho and theta
    theta = -180:1:179;
    rho = -maxrho:1:maxrho;
    %Initialize the accumulator array
    accumulator = zeros(length(rho),length(theta));
    %Loop over all the edge pixels
    for y=1:row
        for x=1:col
            if img(y,x)==1
                for k=1:length(theta)
                    %Find the rho for particular theta
                    angle = theta(k)*pi/180;
                    temprho = x*cos(angle) + y*sin(angle);
                    %get the nearest value to the temprho calculated above
                    [diff,dist] = min(abs(rho-temprho));
                    if(diff<=1)
                        %Update the accumulator array with the vote
                        accumulator(dist,k) = accumulator(dist,k) + 1;
                    end
                end
            end
        end
    end
    %Scale the accumulator array
    accumulator = mat2gray(accumulator,[min(accumulator(:)) max(accumulator(:))]);
    %Find the peaks in the hough space and printout the line params
    find_peaks(accumulator,length(rho),maxrho);
end