function [wimgs,param] = estwarp_condens(frm, tmpl, param, opt)
%% function [wimgs,param] = estwarp_condens(frm, tmpl, param, opt)
%%parameters samples and estimates the optimization
%%Input:
%       frm      :     original 2D image
%       tmpl     :     target template
%       param    :     sample parameters
%       opt      :     other options
%%Output:
%       wimgs    :     all samples
%       param    :     updated parameters with estimated optimization

%% Copyright (C) Jongwoo Lim and David Ross.
%% All rights reserved.

n = opt.numsample;
param.sz = size(tmpl.mean);
N = param.sz(1)*param.sz(2);

if ~isfield(param,'param')
  param.param = repmat(affparam2geom(param.est(:)), [1,n]);
else
  cumconf = cumsum(param.conf);
  idx = floor(sum(repmat(rand(1,n),[n,1]) > repmat(cumconf,[1,n])))+1;
  param.param = param.param(:,idx);
end
param.param = param.param + randn(6,n).*repmat(opt.affsig(:),[1,n]);
wimgs = warpimg(frm, affparam2mat(param.param), param.sz);
param.diff = repmat(tmpl.mean(:),[1,n]) - reshape(wimgs,[N,n]);
coefdiff = 0;
if (size(tmpl.basis,2) > 0)
  coef = tmpl.basis'*param.diff;
  param.diff = param.diff - tmpl.basis*coef;
  if (isfield(param,'coef'))
    coefdiff = (abs(coef)-abs(param.coef))*tmpl.reseig./repmat(tmpl.eigval,[1,n]);
  else
    coefdiff = coef .* tmpl.reseig ./ repmat(tmpl.eigval,[1,n]);
  end
  param.coef = coef;
end
if (~isfield(opt,'errfunc'))  opt.errfunc = [];  end
switch (opt.errfunc)
  case 'robust';
    param.conf = exp(-sum(param.diff.^2./(param.diff.^2+opt.rsig.^2))./opt.condenssig)';
  case 'ppca';
    param.conf = exp(-(sum(param.diff.^2) + sum(coefdiff.^2))./opt.condenssig)';
  otherwise;
    param.conf = exp(-sum(param.diff.^2)./opt.condenssig)';
end
param.conf = param.conf ./ sum(param.conf);
[maxprob,maxidx] = max(param.conf);
param.maxprob = maxprob;
param.maxidx = maxidx;
maxprob