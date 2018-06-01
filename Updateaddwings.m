function   param = Updateaddwings(wimgs, param, confidenceMap)
%% function   param = Updateaddwings(wimgs, param, confidenceMap)
%%updates other parameters
%%Input:
%       wimgs        :  all samples
%       param        :  sample parameters
%       confidenceMap:  confidence values of all test samples
%%Output:
%       param        :  updated parameters

%[ value,HOGIndex ] = sort(confidenceMap.HOG ,'descend');
%HOGpositiveIndex = HOGIndex(1:65);
%HOGnegativeIndex = HOGIndex(201:265);
%param.HOGpositive = param.param(:,HOGpositiveIndex');
%param.HOGnegative = param.param(:,HOGnegativeIndex');

%[ value,RGBIndex ] = sort(confidenceMap.RGB ,'descend');
%RGBpositiveIndex = RGBIndex(1:65);
%RGBnegativeIndex = RGBIndex(201:265);
%param.RGBpositive = param.param(:,RGBpositiveIndex');
%param.RGBnegative = param.param(:,RGBnegativeIndex');

param.est = affparam2mat(param.param(:,param.maxidx));
param.combineest = affparam2mat(param.param(:, param.combinemaxidx));
param.wimg = wimgs(:,:,param.combinemaxidx);
param.err = reshape(param.diff(:,param.maxidx), param.sz);
param.recon = param.wimg + param.err;