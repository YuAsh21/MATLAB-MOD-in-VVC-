clear all;
close all;
clc

% HM-master3
% VVCSoftware_VTM-master23

fontSize = 15;
%Reading Image & converting data type to double
pFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/after'; %reverse
bFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p/otsu';
myFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p';
filePattern = fullfile(myFolder, '*.png'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
theFiles = natsortfiles(theFiles);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
img=imread(fullFileName);

% [lehisto x]=imhist(img);
% [level]=triangle_th(lehisto,256);
% img = medfilt2(img, [2 2]);
% img=im2bw(img,level);
% img = medfilt2(img, [5 5]);
% img = filter2(fspecial('average',5),img)/255;
% img = wiener2(img,[5 5]);
% w     = 5;       % bilateral filter half-width
% sigma = [3 0.1]; % bilateral filter standard deviations

% Apply bilateral filter to each image.
% img = double(img)/255;
% double(imread('einstein.jpg'))/255
% img = bfilter2(img,w,sigma);
% img = image_denoise_gray_news (img);
img = medfilt2(img, [3 3]);
img = imbilatfilt(img);
img = imbinarize(img);
sFileName = sprintf('%d.png', k); % e.g. "1.png"
fFileName = fullfile(bFolder, sFileName); % No need to worry about slashes now!
imwrite(img, fFileName);


% imshow (img)
% figure

%  proc = bwpropfilt(img,'perimeter',10);

  se = strel('rectangle',[3 3]);
%  proc = bwareaopen(img, 1);
% proc = imfill(img, 'holes');
 proc = imclose(img,se);
 proc = imfill(proc, 'holes');
%  
%  imshow (proc)
%  figure
% % proc = imfill(proc, 'holes');
% imshow (proc)
%  figure
% %  imshow (proc)
% %  figure
% %  proc = bwareafilt(proc,1);
% % imshow (proc);
% 
sFileName = sprintf('%d.png', k); % e.g. "1.png"
fFileName = fullfile(pFolder, sFileName); % No need to worry about slashes now!
imwrite(proc, fFileName);

end