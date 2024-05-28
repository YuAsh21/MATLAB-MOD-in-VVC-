%       https://matlabgeek.blogspot.com/2022/02/balanced-histogram-thresholding-with.html

clear all; 
close all;
clc

fontSize = 15;

% Reading Image & converting data type to double
% myFolder = '/Users/mac/Documents/HM-master3/office-ss-p';
% imageDir = fullfile(myFolder, '*.png');
% imageDir = natsortfiles(imageDir);
% theFiles = dir(imageDir);

% HM-master3
% VVCSoftware_VTM-master23
% 
 pFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht';

% dataSetDir = '/Users/mac/Documents/HM-master3/office-ss-p';
% imageDir = fullfile(dataSetDir, '*.png');
% imageDir = natsortfiles(imageDir);
% theFiles = dir(imageDir);
% imds = imageDatastore(imageDir); 
% imds.Files=natsortfiles(imds.Files);

myFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p';
filePattern = fullfile(myFolder, '*.png'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
theFiles = natsortfiles(theFiles);

k = length(theFiles);
for i = 1:k
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(theFiles(i).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
%     img = readimage(imds,i);
 img=imread(fullFileName);

% img=imread('hike3e.jpg');
% img(:,:,[2:3]= [] % uncomment this if image is rgb
% figure
% subplot(2,1,1)
% imshow(img)
% title('Original Image')
img=double(img);

% img5 = imadjust(img);
% figure
% imshow(img5);
% title('adjusted image');

I=img(:);           % Calculating Histogram
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
nimg=zeros(size(img));
rng=size(img);
for ii=1:rng(1)
    for jj=1:rng(2)
        if img(ii,jj)<=(mdpnt/10) %point from where the image's background is separated
            nimg(ii,jj)=255;
        else
            nimg(ii,jj)=0;
        end
    end
end


% subplot(2,1,2)
% imshow(nimg)
% title('Processed Image')
 nimg = imcomplement(nimg);
% nimg = imbinarize(nimg);
% Kmedian = image_denoise_gray_news (nimg);
xFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht-m'
yFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht-b'
zFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht-p'
eFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht-f'
fFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht-c'
gFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/bht-a'

 Kmedian = medfilt2(nimg, [2 2]);
  sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(xFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
%  Kmedian = imbilatfilt(Kmedian);
%   Kmedian = bwareafilt(Kmedian,1);
Kmedian = imbinarize(Kmedian);
 sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(yFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
%   Kmedian = bwareafilt(Kmedian,1);
  Kmedian = bwpropfilt(Kmedian,'perimeter',10);
   sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(zFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
%   Kmedian = bwareafilt(Kmedian,1);
%  Kmedian = bwareafilt(Kmedian,1);
% Kmedian = bwareafilt(Kmedian,1);
se = strel('disk',3);
se2 = strel('rectangle',[3 3]);
% Kmedian = imerode(Kmedian, se2);
% Kmedian = bwareaopen(Kmedian, 1);
%  Kmedian = imfill(Kmedian, 'holes');

% Kmedian = imclose(Kmedian,se2);

 Kmedian = imfill(Kmedian, 'holes');
  sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(eFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
 Kmedian = imclose(Kmedian,se);
  sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(fFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
  Kmedian = bwareafilt(Kmedian,1);
   sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(gFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);


% se = strel('disk',5);
% se2 = strel('disk',1);
% Kmedian = imerode(Kmedian, se2);
% % % Kmedian = bwareaopen(Kmedian, 1000);
% %  Kmedian = bwareaopen(Kmedian, 1);
% 
% Kmedian = imclose(Kmedian,se);
% 
% Kmedian = imfill(Kmedian, 'holes');
% noiseImage = (nimg == 0 | nimg == 255);
% % Get rid of the noise by replacing with median.
% noiseFreeImage = nimg; % Initialize
% noiseFreeImage(noiseImage) = medfilt2(noiseImage); % Replace.
% % Display the image.
% % subplot(2, 1, 3);
% figure
% imshow(noiseFreeImage);
% title('Restored Image', 'FontSize', fontSize);
% figure
%  imshowpair(nimg,Kmedian,'montage')
 
 sFileName = sprintf('%d.png', i); % e.g. "1.png"
fFileName = fullfile(pFolder, sFileName); % No need to worry about slashes now!
imwrite(Kmedian, fFileName);
 
% imwrite(Kmedian, 'hike4e.jpg');
%  kmedian2 = medfilt2(Kmedian);
%  figure
%  imshowpair(Kmedian, kmedian2,'montage')
%  kmedian3 = medfilt2(kmedian2);
%  se = strel('disk',10);
%  kemdian3 = imclose(kmedian3,se);
%   kemdian3 = imdilate(kmedian3,se);
%  kemdian3 = imfill(kmedian3,'holes');
%  figure
%  imshowpair(kmedian2, kmedian3,'montage')


I=nimg(:);           % Calculating Histogram
hst2=zeros(1,256);
for ii =0:255
    hst2(ii+1)=sum(I==ii);
end
% figure
% subplot(2,1,1)
% stem(hst)
% grid on
% title('original Image Histogram')
% axis([1 256 0 65000])
% subplot(2,1,2)
% stem(hst2)
% title('processed Image Histogram')
% 
% figure
% stem(hst)
% grid on
% %axis([0 172 0 65000])
% hold on
% stem(mdpnt,hst(mdpnt),'red', 'linewidth',2)
disp('The balanced threshold value of Histogram is :')
disp(mdpnt)
end