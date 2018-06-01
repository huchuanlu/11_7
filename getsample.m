function sampleStrong = getsample(frame,param,opt)
%% function sampleStrong = getsample(frame,param,opt)
%%extracts RGB and HOG features for positives and negatives 
%%Input:
%       frame          :   original 3D image
%       param          :   sample parameters
%       opt            :   other options
%%Output:
%       sampleStrong   :   RGB and HOG features and labels for positives and negatives

%%HOG parameters
angle = 180;    HOGBins = 8;
HOGBlockNumber = [ 8 8 ];  HOGblockSize   = [ 8 8 ]; T = 5;

%%RGB parameters
%RGBBins = 4; RGBBlockNumber = [4 4 ];
%flag = 1;
%RGBBins = 2*2;
%RGBBlockSize = [ 8 8 ];

%%initialize features and labels
sampleStrong.posxHOG = [];%sampleStrong.posxRGB = [];
sampleStrong.negxHOG = [];%sampleStrong.negxRGB = []; 
sampleStrong.newSampleLabel = []; sampleStrong.instanceTarget = [];

framegray = double(rgb2gray(frame))/256;
frame= double(frame)/256;

for i = 1: size(param.positive,2)
     psample(:,:,1) = warpimg(frame(:,:,1) , param.positive(:,i)' , opt.tmplsize);
     psample(:,:,2) = warpimg(frame(:,:,2) , param.positive(:,i)' , opt.tmplsize);
     psample(:,:,3) = warpimg(frame(:,:,3) , param.positive(:,i)' , opt.tmplsize);
     psamplegray = warpimg(framegray , param.positive(:,i)' , opt.tmplsize);
     
     [ valueMap HOGindexMap ] = hog(round(psamplegray*256), angle,HOGBins,T);
     [ tempHOG sz ] = blockStatistic(valueMap, HOGindexMap,HOGBlockNumber, HOGblockSize,HOGBins, flag);
     sampleStrong.posxHOG = cat(2,sampleStrong.posxHOG,tempHOG);

     %[ RGBindexMap binsIndex ] = rgbQuantification(round(psample*256),4,1);
     %[ tempRGB sz ] = rgbHistBlock( RGBindexMap, RGBBlockSize, RGBBins );
     %sampleStrong.posxRGB  = cat(2,sampleStrong.posxRGB,tempRGB);

     sampleStrong.newSampleLabel  = cat(2,sampleStrong.newSampleLabel,+1);
     sampleStrong.instanceTarget  = cat(2,sampleStrong.instanceTarget,1);
end

for i = 1: size(param.negative,2)
     nsample(:,:,1) = warpimg(frame(:,:,1) , param.negative(:,i)',opt.tmplsize);
     nsample(:,:,2) = warpimg(frame(:,:,2) , param.negative(:,i)',opt.tmplsize);
     nsample(:,:,3) = warpimg(frame(:,:,3) , param.negative(:,i)',opt.tmplsize);
     nsamplegray = warpimg(framegray , param.negative(:,i)',opt.tmplsize);
     
     [ valueMap HOGindexMap ] = hog(round(nsamplegray*256), angle, HOGBins,T);
     [ tempHOG sz ] = blockStatistic(valueMap, HOGindexMap,HOGBlockNumber, HOGblockSize,HOGBins, flag);
     sampleStrong.negxHOG = cat(2, sampleStrong.negxHOG,tempHOG);

     %[ RGBindexMap binsIndex ] = rgbQuantification(round(nsample*256),4,1);
     %[ tempRGB sz ] = rgbHistBlock( RGBindexMap, RGBBlockSize, RGBBins );
     %sampleStrong.negxRGB= cat(2,sampleStrong.negxRGB,tempRGB);
   
     sampleStrong.newSampleLabel  = cat(2,sampleStrong.newSampleLabel,-1); 
     sampleStrong.instanceTarget  = cat(2,sampleStrong.instanceTarget,i+1);
end