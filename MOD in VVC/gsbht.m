

%       https://matlabgeek.blogspot.com/2022/02/balanced-histogram-thresholding-with.html

clear all; 
close all;
clc

% HM-master3
% VVCSoftware_VTM-master23
 pFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/people-ss-p/gsbht';

myFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/people-ss-p';
filePattern = fullfile(myFolder, '*.png'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
theFiles = natsortfiles(theFiles);

k = length(theFiles);
for i = 1:k
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(theFiles(i).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    

 img=imread(fullFileName);


%greyslice

nimg = grayslice(img, 4);

% Kmedian = medfilt2(nimg, [2 2]);
 
 %add bht
 
nimg=double(nimg);

I=nimg(:);           % Calculating Histogram
hst=zeros(1,256);
for ii =0:255
    hst(ii+1)=sum(I==ii);
end

for ii=1:256        % Calculating Start Point
    if hst(ii)>0
        stpt=ii;
        break
    end
end
for ii=256:-1:1     % Calculating End point
    if hst(ii)>0
        endpt=ii;
        break
    end
end
mdpnt=round((stpt+endpt)/2);    %mid point
lsum=sum(hst(stpt:mdpnt));      % sum of left side
rsum=sum(hst(mdpnt:endpt));     % sum of right side
while lsum ~= rsum              % iterative process of finding
    if rsum>lsum                % balanced mid point
        endpt=endpt-1;
        if round((stpt+endpt)/2)< mdpnt
            mdpnt=mdpnt+1;
            lsum=sum(hst(stpt:mdpnt));
            rsum=sum(hst(mdpnt:endpt));
            
        end
    else
        stpt=stpt+1;
        if round((stpt+endpt)/2) > mdpnt
            mdpnt=mdpnt-1;
            lsum=sum(hst(stpt:mdpnt));
            rsum=sum(hst(mdpnt:endpt));
            
        end
    end
            
            
end

% for image processing
mimg=zeros(size(nimg));
rng=size(nimg);
for ii=1:rng(1)
    for jj=1:rng(2)
        if nimg(ii,jj)<=(mdpnt/10) %point from where the image's background is separated
            mimg(ii,jj)=255;
        else
            mimg(ii,jj)=0;
        end
    end
end

% nimg = imcomplement(nimg);
 
%convert to binary
% nimg = imcomplement(nimg);
Kmedian = medfilt2(nimg, [2 2]);

Kmedian = imbinarize(Kmedian);

   Kmedian = bwpropfilt(Kmedian,'perimeter',10);
  se = strel('disk',3);
se2 = strel('rectangle',[3 3]);
 Kmedian = imfill(Kmedian, 'holes');
 Kmedian = imclose(Kmedian,se);
  Kmedian = bwareafilt(Kmedian,1);

% se = strel('disk',12);
% se2 = strel('rectangle',[12 12]);
% 
% 
% 
%  Kmedian = imfill(Kmedian, 'holes');
%  Kmedian = imclose(Kmedian,se2);


%%saving file
 
 sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(pFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
 




end