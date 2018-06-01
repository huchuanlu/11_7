function [nSampleCenter]=samplenegX(locationCenter,targetWindowSize,rows,cols)
%% function [nSampleCenter]=samplenegX(locationCenter,targetWindowSize,rows,cols)
%%random samples negatives
%%Input:       
%       locationCenter   £º         location center of target
%       targetWindowSize :          size of negatives
%       rows             :          height of original frame
%       cols             :          width of original frame
%%Output:
%       nSampleCenter    £º         location centers of negatives    

k = 1;
while(k<=65)
    x  = round(locationCenter(1)-50 + rand*100);
    y  = round(locationCenter(2)-50 + rand*100);
    tempx = x - locationCenter(1);
    tempy = y - locationCenter(2);
    minx = x - targetWindowSize(1)/2; miny = y - targetWindowSize(2)/2;
    maxx = x + targetWindowSize(1)/2; maxy = y + targetWindowSize(2)/2; 
    if ((( tempx*tempx + tempy*tempy)>1500)&&(( tempx*tempx + tempy*tempy)<2500)&&(minx>0)&&(miny>0)&&(maxx<cols)&&(maxy<rows))
        nSampleCenter(1,k) = x;
        nSampleCenter(2,k) = y;
        k = k + 1;
    end;
end;