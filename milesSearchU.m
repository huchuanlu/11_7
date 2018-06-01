function U   =  milesSearchU(KS,WE,testHOG,sigma2);
%% function U   =  milesSearchU(KS,WE,testHOG,sigma2);
%%locates the target with the maximal contribution to classification of bags
%%Input:
%       KS         :    support instances
%       WE         :    weights of support instances
%       testHOG    :    HOG feature of test samples
%       sigma2     :    sigma^2  
%%Output:
%       U   :   target location with the maximal contribution to classification

[d,n] = size(KS);
len = size(testHOG{1},2);
junk = zeros(n,size(testHOG{1},2));
 for k = 1:n
     for j = 1:len
            junk(k,j) = norm(testHOG{1}(:,j) - KS(:,k));
     end
 end
 sumvalue =zeros(len,1);
 junk = exp(-junk.^2./sigma2);
 [value_mu,index_mu ] = max(junk,[],2);
 for jj = 1:len
     for ii = 1:n     
        if index_mu(ii,1) ==jj
            sumvalue (jj,1) = sumvalue(jj,1)+ WE(ii)*value_mu(ii,1);
        end
     end
 end
 for kk = 1:len
    if  sumvalue(kk,1)==0
        sumvalue(kk,1)=-inf;
    end
 end
 [V,U] = max(sumvalue);