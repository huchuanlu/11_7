function   Alltest = getallsample ( frame,param,opt)
%% function   Alltest = getallsample ( frame,param,opt)
%%extracts RGB and HOG features for all test samples 
%%Input:
%       frame     :     original 3D image
%       param     :     sample parameters
%       opt       :     other options
%%Output:
%       Alltest   :     RGB and HOG features and labels for all test samples

%%HOG parameters
angle = 180;    HOGBins = 8;
HOGBlockNumber = [ 8 8 ];  HOGblockSize   = [ 8 8 ]; T = 5;

%%RGB parameters
%RGBBins = 4; RGBBlockNumber = [4 4 ];
%flag = 1;
%RGBBins =2*2*2*2*2;
%RGBBlockSize = [ 8 8 ];

%%initialize features and labels
Alltest.HOG = []; %Alltest.RGB = [];  
Alltest.newSampleLabel = [];  Alltest.instanceTarget = [];
 
framegray = double(rgb2gray(frame))/256;
frame= double(frame)/256;

for i = 1: size(param.param,2)
     psample(:,:,1) = warpimg(frame(:,:,1) , param.param(:,i)' , opt.tmplsize);
     psample(:,:,2) = warpimg(frame(:,:,2) , param.param(:,i)' , opt.tmplsize);
     psample(:,:,3) = warpimg(frame(:,:,3) , param.param(:,i)' , opt.tmplsize);
     psamplegray = warpimg(framegray , param.param(:,i)' , opt.tmplsize);
     
     [ valueMap HOGindexMap ] = hog(round(psamplegray*256), angle,HOGBins,T);
     [ tempHOG sz ] = blockStatistic(valueMap, HOGindexMap,HOGBlockNumber, HOGblockSize,HOGBins, flag);
     Alltest.HOG = cat(2, Alltest.HOG,tempHOG);

     %[ RGBindexMap binsIndex ] = rgbQuantification(round(psample*256),4,1);
     %[ tempRGB sz ] = rgbHistBlock( RGBindexMap, RGBBlockSize, RGBBins );
     %Alltest.RGB  = cat(2, Alltest.RGB ,tempRGB);

     Alltest.newSampleLabel  = cat(2, Alltest.newSampleLabel,+1);
     Alltest.instanceTarget  = cat(2, Alltest.instanceTarget,1);
end