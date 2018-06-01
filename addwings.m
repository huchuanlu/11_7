function param = addwings( wimgs, param )
%% function param = addwings( wimgs, param )
%%obtains positives and negatives and adds parameters
%%Input:
%       wimgs     :     all samples
%       param     :     parameters with estimated optimization
%%Output:
%       param     :     updated parameters with positives and negatives

[ value,Index ] = sort(param.conf ,'descend');
positiveIndex = Index(1:65);
negativeIndex = Index(201:265);
param.positive = param.param(:,positiveIndex');
param.negative = param.param(:,negativeIndex');
param.est = affparam2mat(param.param(:,param.maxidx));
param.wimg = wimgs(:,:,param.maxidx);
param.err = reshape(param.diff(:,param.maxidx), param.sz);
param.recon = param.wimg + param.err;