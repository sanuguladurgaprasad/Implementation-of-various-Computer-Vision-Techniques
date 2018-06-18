function prog1(ip)
    %read and plot the original image
    I=imread(ip);
    subplot(339),imshow(I),title('Original Image');
    
    %convert the original image to grayscale
    I=rgb2gray(I);
    row = size(I,1);
    col = size(I,2);
    
    %Roberts and Sobel operators
    RobertX = [0 1;-1 0];
    RobertY = [1 0;0 -1];
    SobelX = [-1 0 1;-2 0 2;-1 0 1];
    SobelY = [1 2 1;0 0 0;-1 -2 -1];
    
    %Rimg is the padded image of the grayscale
    %Rmag and Rdir are the Roberts magnitude and direction images
    Rimg = zeros(row+1,col+1);
    Rimg(1:row,1:col) = I; 
    Rmag = zeros(row,col);
    Rdir = zeros(row,col);
    
    %convolute the Roberts operator with the Rimg
    for i=1:row
        for j=1:col
            magX = sum(sum(RobertX.*Rimg(i:i+1,j:j+1)));
            magY = sum(sum(RobertY.*Rimg(i:i+1,j:j+1)));
            Rmag(i,j) = sqrt(magX^2 + magY^2);
            Rdir(i,j) = atan2(magY,magX);
        end
    end
    
    %scale the values so that they lie between 0 and 1
    Rmag = mat2gray(Rmag,[min(Rmag(:)) max(Rmag(:))]);
    Rdir = mat2gray(Rdir,[min(Rdir(:)) max(Rdir(:))]);
    
    %Plotting and writing back the images to the current folder
    subplot(331),imshow(Rmag),title('Roberts Magnitude Image');
    subplot(332),imshow(Rdir),title('Roberts Direction Image');
    imwrite(Rmag, 'Roberts Magnitude Image.png');
    imwrite(Rdir, 'Roberts Direction Image.png');
    
    %Thresholding of Rmag. Plotting it and writing back to the current folder
    Rmag_threshold=threshold(floor(Rmag*255));
    subplot(333),imshow(Rmag_threshold),title('Roberts Threshold Image');
    imwrite(Rmag_threshold, 'Roberts Threshold Image.png');
    
    %Simg is the padded image of the grayscale
    %Smag and Sdir are the Sobel magnitude and direction images
    Simg = zeros(row+2,col+2);
    Simg(2:row+1,2:col+1) = I; 
    Smag = zeros(row,col);
    Sdir = zeros(row,col);
    
    %convolute the Sobel operator with the Simg
    for i=1:row
        for j=1:col
            magX = sum(sum(SobelX.*Simg(i:i+2,j:j+2)));
            magY = sum(sum(SobelY.*Simg(i:i+2,j:j+2)));
            Smag(i,j) = sqrt(magX^2 + magY^2);
            Sdir(i,j) = atan2(magY,magX);
        end
    end
    
    %scale the values so that they lie between 0 and 1
    Smag = mat2gray(Smag,[min(Smag(:)) max(Smag(:))]);
    Sdir = mat2gray(Sdir,[min(Sdir(:)) max(Sdir(:))]);
    
    %Plotting and writing back the images to the current folder
    subplot(334),imshow(Smag),title('Sobel Magnitude Image');
    subplot(335),imshow(Sdir),title('Sobel Direction Image');
    imwrite(Smag, 'Sobel Magnitude Image.png');
    imwrite(Sdir, 'Sobel Direction Image.png');
    
    %Thresholding of Smag. Plotting it and writing back to the current folder
    Smag_threshold=threshold(floor(Smag*255));
    subplot(336),imshow(Smag_threshold),title('Sobel Threshold Image');
    imwrite(Smag_threshold, 'Sobel Threshold Image.png');
    
    %STENTIFORD THINNING ALGORITHM
    %store Rmag ans Smag in cell array so that we can traverse and thin both
    images{1} = Rmag_threshold;
    images{2} = Smag_threshold;
    for count = 1:2
        %op is the output image 
        op=zeros(row+2,col+2);
        %op1 is the image which keeps track of marked pixels to delete
        op1=zeros(row+2,col+2);
        %now op is the padded image of the magnitide image
        op(2:row+1,2:col+1)=images{count};
        %Template T1 in Stentiford Thinning algorithm
        template = [-1,0,-1;-1,255,-1;-1,255,-1];
        %no_changes keeps track of chagnes to op1 image
        no_changes=0;
        itr=0;
        %iterate until there are no changes with the four templates consecutively
        %I iterate for 8 consecutive no_changes to be on safer side
        while (no_changes < 8)
            itr=itr+1;
            for i=1:row
                for j=1:col
                    match=0;
                    %checks whether T1 or T3 matches with image window
                    if (itr==1 || itr==3) & (op(i:i+2,j+1)==template(1:3,2))
                        match=1;
                    %checks whether T2 or T4 matches with image window
                    elseif (itr==2 || itr==4) & (op(i+1,j:j+2)==template(2,1:3))
                        match=1;
                    end
                    %If the template matches calculate connectivity and
                    %check if it is the end/lone pixel
                    if (match==1)
                        [connectVal,isEnd] = checkConnectandEnd(op(i:i+2,j:j+2));
                        if (connectVal==1) && (isEnd~=1)
                            %If it is not end/lone pixel and onnectivity is
                            % 1 then mark the pixel to delete
                            op1(i+1,j+1)=1;
                        end
                    end
                end
            end
            %find the positions in the op1 where the pixels were marked to delete
            pos = find(op1==1);
            %compute the change in op1 and update no_changes
            change = sum(sum(op1));
            if (change==0)
                no_changes = no_changes+1;
            else
                no_changes=0;
            end
            %Change the corresponding pixel values in output image op to 0
            op(pos)=0;
            %Initialize the op1 with zeros for a fresh start
            op1(pos)=0;
            %Generate next template in Stentiford
            template=rot90(template);
            if itr==5
                itr=1;
            end
        end
        %remove padding
        op=uint8(op(2:row+1,2:col+1));
        if count==1
            %Plot the thinned Roberts image write back the image to current folder
            subplot(337),imshow(op),title('Roberts Thinned Image');
            imwrite(op, 'Roberts Thinned Image.png');
        else
            %Plot the thinned Sobels image write back the image to current folder
            subplot(338),imshow(op),title('Sobel Thinned Image');
            imwrite(op, 'Sobel Thinned Image.png');
        end
    end
end

%connectivity algorithm which counts the 8 connected components
function [connectVal,isEnd] = checkConnectandEnd(imgTemp)
    %store the pixel values starting from
    %center pixel and moving in a counterclock wise direction towards right
    N = [imgTemp(2,2) imgTemp(2,3) imgTemp(1,3) imgTemp(1,2) imgTemp(1,1) imgTemp(2,1) imgTemp(3,1) imgTemp(3,2) imgTemp(3,3)];
    N=N/255;
    %check if the pixel is a lone/end pixel
    if sum(N)-N(1)<2
        isEnd=1;
    else
        isEnd=0;
    end
    %Take complement of N
    for i=1:9
         N(i)=1-N(i);
    end
    %calculate connectivity using the connectivity formula given in the report
    connectVal = N(2)*(1-N(3)*N(4)) + N(4)*(1-N(5)*N(6)) + N(6)*(1-N(7)*N(8)) + N(8)*(1-N(9)*N(2));
end

%Select a threshold manually and segment the image into 2 classes (0 and 255)
function [img] = threshold(img)
    for i=1:size(img,1)
        for j=1:size(img,2)
            if(img(i,j)<40)
                img(i,j)=0;
            else
                img(i,j)=255;
            end
        end
    end
end