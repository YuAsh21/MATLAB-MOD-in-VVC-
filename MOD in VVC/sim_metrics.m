
clc;
clear all;
close all; 

% HM-master3
% VVCSoftware_VTM-master23

dataSetDir = '/Users/mac/Documents/bgslibrary-3.2.0/output/vvc-vibe-swing';
imageDir = fullfile(dataSetDir, '*.png');
imageDir = natsortfiles(imageDir);
theFiles = dir(imageDir);
imds = imageDatastore(imageDir); 
imds.Files=natsortfiles(imds.Files);
% view data set images origional
Is = [];
% figure
k = length(theFiles);

for i = 1:k
%     subplot(5,5,i)
    I = readimage(imds,i);
    I = imresize (I,[59 89]);
%     I=imbinarize(I);
    I = ~I;
%     [j k] = size (I);
% ResImage{i}=imresize(Is{end+1},[j k]);
    Is{end+1} = I;
%     imshow(I)
%     title('training labels')
    
end
%% second, read the binary images after segmentation
dataSetDir1 = fullfile('/Users/mac/Documents/HM-Master3/swing-ss-p/gt');
% imageDir1 = fullfile(dataSetDir1);
imageDir1 = fullfile(dataSetDir1, '*.png');
theFiles1 = dir(imageDir1);
imds1 = imageDatastore(imageDir1);
% view data set images origional
Is2 = [];
% figure

for ii = 1:k
%     subplot(5,5,ii)
    II = readimage(imds1,ii);
    II = imbinarize(II, 'adaptive');
[m n] = size (I);
img2 = imresize (II,[m n]);
  img2 = ~img2;
% img2 = imbinarize(IIr, 'adaptive');
% II = imresize(II, size(I));
% II = imbinarize(II);
    Is2{end+1} = img2;
    
%     imshow(img2)
%     title('binary labels')
   
end
%% compare the dice similarity for every slice, like 1 with 1, 2 with 2, 3 with 3....and so on till 23 with 23..
similarity = [];
for i = 1 : k
     similarity(i) = dice(Is{i}, Is2{i});
%     similarity(i) = dice(Is{i}, Is2{i});
    fprintf('the jaccard similarity for %d with %d is %.3f\n', i, i, similarity(i));
%     figure
FN(i) = nnz(~Is{i} & Is2{i});
FP(i) = nnz(Is{i} & ~Is2{i});
TP(i) = nnz(Is{i} & Is2{i});
TN(i) = nnz(~Is{i} & ~Is2{i});

  Accuracy(i) = (TP(i)+TN(i))/(FN(i)+FP(i)+TP(i)+TN(i));
    Recall(i) = TP(i)/(TP(i)+FN(i));
    Precision(i) = TP(i)/(TP(i)+FP(i));
     Fmeasure(i) = 2*TP(i)/(2*TP(i)+FP(i)+FN(i));
% Fmeasure(i) = 2*(Precision(i)*Recall(i))/(Precision(i)+Recall(i));
    MCC = (TP(i)*TN(i)-FP(i)*FN(i))/sqrt((TP(i)+FP(i))*(TP(i)+FN(i))*(TN(i)+FP(i))*(TN(i)+FN(i)));
%     avg_precision = (sum(Precision))/i;


% imshowpair(Is{i}, Is2{i})
% title(['IoU = ' num2str(similarity(i))])


%     M = mean(similarity)

end
avg_acc = mean(Accuracy);

avg_recall = mean(Recall);

avg_precision = mean(Precision,"omitnan");
% avg_precision = sum(Precision);

avg_fm = mean(Fmeasure);

avg_IOU = mean(similarity);