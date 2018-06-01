% K = milesfeaturemapping(C,D,sigma2)
%
% Map all bags in D to points in an instance-based feature space
% constructed using columns of C.
%
% Input:
%       C-- A d x n matrix where d is the dimension of instance
%           feature vectors, n is the number of instances used 
%           in constructing the instance-based feature mapping.
%           It can be the instances in all the training bags.
%       D-- A 1 x m cell array containing bags. Each cell is a bag, 
%           which is a matrix. Each column of the matrix is an
%           instance.
%       sigma2-- parameter sigma^2 in line 4 of Algorithm 4.1 in
%            PAMI MILES paper.
% Output:
%       K-- A m x n matrix. Each row corresponds to a bag.
%           Using the notation in PAMI MILES paper,
%           K_{i,j} = s(x^j,B_i)=exp(-d^2/sigma^2) where
%           d = min_{x \in B_i} ||x - x^j||
%
% Yixin Chen, June 5, 2006
% ychen@cs.olemiss.edu
%
function K = milesfeaturemapping(C, D, sigma2)
[d,n] = size(C);
m = length(D);
K = zeros(m,n);
for i = 1:m
    junk = zeros(size(D{i},2),n);
    for j = 1:size(D{i},2)
        for k = 1:n
            junk(j,k) = norm(D{i}(:,j) - C(:,k));
        end
        K(i,:) = min(junk,[],1);
    end
end
K = exp(-K.^2./sigma2);