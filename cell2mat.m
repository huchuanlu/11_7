% function A = cell2mat(C,d)
% C is a 1 x m or m x 1 cell array of matrices of the same 
% number of rows if d = 2, or the same number of columns
% if d = 1.
% If d = 1, A returns a matrix built from vertically stacking
% cells of A.
% If d = 2, A returns a matrix built from horizontally stacking
% cells of A
%
% Yixin Chen, June 6, 2006
% Email: ychen@cs.olemiss.edu
%
function A = cell2mat(C,d)
m = length(C);
n = 0;
if d == 1
    t = size(C{1},2);
    for i = 1:m
        n = n + size(C{i},1);
    end
    A = zeros(n,t);
else
    t = size(C{1},1);
    for i = 1:m
        n = n + size(C{i},2);
    end
    A = zeros(t,n);
end
if d == 1
    cnt = 1;
    for i = 1:m
        A(cnt:cnt+size(C{i},1)-1,:) = C{i};
        cnt = cnt + size(C{i},1);
    end
else
    cnt = 1;
    for i = 1:m
        A(:,cnt:cnt+size(C{i},2)-1) = C{i};
        cnt = cnt + size(C{i},2);
    end
end