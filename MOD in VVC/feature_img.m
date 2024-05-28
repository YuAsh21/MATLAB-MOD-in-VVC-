clear all; 
close all;
clc


myFolder = '/Users/mac/Documents/VVCSoftware_VTM-master23/swing-ss-p';
filePattern = fullfile(myFolder, '*.txt'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
theFiles = natsortfiles(theFiles);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
     % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
  
cutable = readtable (fullFileName); % i,w,h,x,y,no.of bits, fbits, dist
% cutable (:,9) = []; %comment for vvc
carray = table2array (cutable);


len = length (carray);
idx = carray (:,1);
w = carray (:,2);
h = carray (:,3);
wh = w.*h;

x = carray(:,4);
y = carray(:,5);
b = carray(:,6);

fb = carray(:,7);
d = carray(:,8);
blk_max = max(w);
ap = 4;

b_we = (blk_max/(wh));

% bd= b.*d;

 
% max_b= max(b); %1859
% b_d = carray(:,6)./1859;
% 
% bin = round(b_d);

var = (255*log2(b))/(max(log2(b)));
% mul = b+fb+d;
% mul2 = mul.+d;


ux = unique(x); dx = min(diff(ux));
uy = unique(y); dy = min(diff(uy));
xidx = 1 + floor((x - ux(1))/dx);
yidx = 1 + floor((y - uy(1))/dy);
im = uint8(accumarray([yidx,xidx], var, [], @mean));
% im3 = uint8(accumarray([yidx,xidx], wh, [], @mean));
% im2 = uint8(accumarray([yidx,xidx], d, [], @mean));
% img1 = imadd(im,im2,'uint8');
% img = imadd(img1,im3,'uint8');
% img = uint8(accumarray([yidx,xidx], d, [], @mean));
% figure
% imshow(img)
% title ('Feature Image')

%  imwrite(img(k), 'img%d.png',k);
%  
sFileName = sprintf('%d.png', k); % e.g. "1.png"
fFileName = fullfile(myFolder, sFileName); % No need to worry about slashes now!
imwrite(im, fFileName);
 
end



