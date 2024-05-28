

%       https://matlabgeek.blogspot.com/2022/02/balanced-histogram-thresholding-with.html

clear all; 
close all;
clc

% HM-master3
% VVCSoftware_VTM-master23
 pFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/people-ss-p/gs';

myFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/people-ss-p';
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

nimg = grayslice(img,2);






%  nimg = imcomplement(nimg);
% nimg = imbinarize(nimg);
% Kmedian = image_denoise_gray_news (nimg);

 Kmedian = medfilt2(nimg, [2 2]);
%   Kmedian = imbilatfilt(Kmedian);
%   Kmedian = bwareafilt(Kmedian,1);
Kmedian = imbinarize(Kmedian);
%   Kmedian = bwareafilt(Kmedian,1);
%   Kmedian = bwpropfilt(Kmedian,'perimeter',10);
%   Kmedian = bwareafilt(Kmedian,1);
%  Kmedian = bwareafilt(Kmedian,1);
% Kmedian = bwareafilt(Kmedian,1);
se = strel('disk',12);
se2 = strel('rectangle',[12 12]);
%  Kmedian = imerode(Kmedian, se2);
% Kmedian = bwareaopen(Kmedian, 1);
%  Kmedian = imfill(Kmedian, 'holes');

% Kmedian = imclose(Kmedian,se2);
%  Kmedian = imclose(Kmedian,se2);
 Kmedian = imfill(Kmedian, 'holes');
 Kmedian = imclose(Kmedian,se2);
%  Kmedian = ~Kmedian;
   Kmedian = bwareafilt(Kmedian,1);


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



end