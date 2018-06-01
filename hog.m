function [ valueMap indexMap ] = hog(im, angle, bins, T)
%% function [ valueMap indexMap ] = hog(im, angle, bins, T )
%%obtains gradient map of magnitude and  oriented gradient map
%%Input£º
%           im              £º image matrix
%           angle           £º angle range
%           bins            :  quantification bin number
%%Output£º
%           valueMap        £º gradient map of magnitude
%           indexMap        £º oriented gradient map
    
if size(im,3) == 3
    imG = rgb2gray(im);
else
    imG = im;
end

[gradientX,gradientY] = gradient(double(imG));                             
valueMap = sqrt((gradientX.*gradientX)+(gradientY.*gradientY));            
index = (gradientX==0); gradientX(index) = 1e-5;                           
YX = gradientY./gradientX;                                                 
valueMap(valueMap<T) = 0;

if angle == 180, angleMap = ((atan(YX)+(pi/2))*180)/pi; end                   
if angle == 360, angleMap = ((atan2(gradientY,gradientX)+pi)*180)/pi; end  
                          
nAngle = angle/bins;                                                       

indexMap = fix((angleMap-1e-5)/nAngle) + 1;                                
indexMap(valueMap<T) = 0;