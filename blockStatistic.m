function [ hst sz ] = blockStatistic(valueMap, indexMap, blockNumber, blockSize, bins, flag)
%%function [ hst sz ] = blockStatistic(valueMap, indexMap, blockNumber, blockSize, bins, flag)
%%counts block histogram
%%Input£º
%      valueMap£º  gradient map of magnitude
%      indexMap£º  oriented gradient map
%   blockNumber:   block number
%     blockSize:   block size
%          bins£º  quantification bin number
%          flag:   if flag==0, determine the sub-block by blockSize
%                  if flag==1, determine the sub-block by blockNumber
%%Output£º
%           hst:   sub-block histogram
%            sz£º  feature dimension

hst = [];

indexMapH  = size(indexMap,1);		
indexMapW  = size(indexMap,2);		
binsIndex = [1:bins];
if valueMap == 0
   clear valueMap;
   valueMap = ones(indexMapH,indexMapW);    
end

if flag == 0
   regionH = blockSize(1);              
   regionW = blockSize(2);             
   numberH = floor(indexMapH/regionH);	
   numberW = floor(indexMapW/regionW);	
   
   for m = 1:numberH      
       for n = 1:numberW        
           a1 = 1+(m-1)*regionH;            
           a2 = m*regionH;
           b1 = 1+(n-1)*regionW;            
           b2 = n*regionW;
           X  = indexMap(a1:a2,b1:b2);      
           Y  = valueMap(a1:a2,b1:b2);     
           temp = zeros(bins,1);                            
           for k = 1:bins
               temp(k) = sum(Y(find(X==binsIndex(k))));    
           end 
           hst = cat(1,hst,temp);               
       end
   end
else
    interval = [ floor(indexMapH/blockNumber(1)),...
                 floor(indexMapW/blockNumber(2)) ]; 
      
    rPosition = zeros(1,blockNumber(1)+1);  
    rPosition(1) = 1; 
    rPosition(blockNumber(1)+1) = indexMapH; 
    for i = 2:blockNumber(1)
        rPosition(i) = rPosition(1) + (i-1)*interval(1);
    end
    
    cPosition = zeros(1,blockNumber(1)+1);
    cPosition(1) = 1; 
    cPosition(blockNumber(1)+1) = indexMapW; 
    for i = 2:blockNumber(1)
        cPosition(i) = cPosition(1) + (i-1)*interval(2);
    end
    
    for i = 1:blockNumber(1)   
        for j = 1:blockNumber(2)    
            a1 = rPosition(i);             
            if i == blockNumber(1)
               a2 = rPosition(i+1);
            else
               a2 = rPosition(i+1)-1;
            end
            b1 = cPosition(j);              
            if j == blockNumber(2)
               b2 = cPosition(j+1);
            else
               b2 = cPosition(j+1)-1;
            end
            X  = indexMap(a1:a2,b1:b2);      
            Y  = valueMap(a1:a2,b1:b2);      
            
            temp = zeros(bins,1);                            
            for k = 1:bins
                temp(k) = sum(Y(find(X==binsIndex(k))));    
            end 
            hst = cat(1, hst, temp);
        end
    end
end

sz = size(hst,1);  