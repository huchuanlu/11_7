% function [w,dualx,z,obj,x]=onenormsvm(K,y,lambda,p)
%
% Solve the following LP problem
% min   lambda*||w||_1 + sum p*xi_i^+ + sum (1-p)*x_i^-
% s.t.  y*(Kw+b) + xi >= 1
%       w, b free, xi >= 0
% 
% If we let w_i = u_i - v_i, u_i,v_i >=0, the above LP 
% is equivalent to
% min lambda*sum(u_i + v_i) + sum p*xi_i^+ + sum (1-p)*x_i^-
% s.t. y*(K*(u-v)+b) + xi >= 1
%      u,v >= 0, xi >= 0
% This is the LP solved by the program.
%
% Inputs:
% K -- feature matrix or kernel matrix, each row is a sample
% y -- class labels (row vector of 1's and -1's), each component 
%      corresponding to a row of K
% lambda -- regularization parameter
% p -- tradeoff between false positive and false negative 
%      errors; p corresponds to false positive, 1-p corresponds
%      to false negative; default value is 0.5;
%
% Outputs:
% w -- the optimal solution of (w b)
% dualx -- the dual solution for each constraint
% z -- the optimal solution of xi
% obj -- the optimal objective value
% x -- the optimal solution of (w b xi)
%
% Yixin Chen, June 6, 2006
% Email: ychen@cs.olemiss.edu
%
function [w,dualx,z,obj,x]=onenormsvm(K,y,lambda,p)

[m,n] = size(K);
if length(y)~=m
    error('K is of wrong matrix dimension');
end
if ~exist('p','var')
    p = 0.5;
end

c = p*ones(m,1);
c(y==-1) = 1-p;
f=[lambda*ones(2*n,1); 0; c];

A=[diag(y)*[K -K ones(m,1)] eye(m)];
clear K;
b=ones(m,1);
lb=[zeros(2*n,1); -1e100; zeros(m,1)];
ub=[];

s=1;
ctype(1:m,1)='S';
vartype(1:(2*n+1+m),1)='C';
param.msglev=1;
lpsolver=1;
save_pb=1;
[x,obj,dualx,status]=glpkmex(s,f,A,b,ctype,lb,ub,vartype,param,lpsolver,save_pb);
% or using the following three lines if CPLEX solver is avaialble
% PARAM = []; OPTIONS = [];
% [x,obj,status,details] = cplexint([],f,-A,-b,[],[],lb,ub,[],PARAM,OPTIONS);
% dualx = details.dual;
w=[x(1:n)-x(n+1:2*n); x(2*n+1)]; % optimal solution of (w b)
z=x(2*n+2:2*n+1+m);
return;