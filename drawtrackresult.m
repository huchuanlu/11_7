function drawopt = drawtrackresult(drawopt, fno, frame, tmpl, param)
%% function drawopt = drawtrackresult(drawopt, fno, frame, tmpl, param)
%%draws track result
%%Input:
%       drawopt      :  draw options
%       fno          :  frame number 
%       frame        :  image data of current frame
%       tmpl         :  target template
%       param        :  sample parameters
%%Output: 
%       drawopt      :  updated draw options

if (isempty(drawopt))  
  figure('position',[0 0 352 288]); clf;                               
  set(gcf,'DoubleBuffer','on','MenuBar','none');
  colormap('gray');

  drawopt.curaxis = [];
  drawopt.curaxis.frm  = axes('position', [0.00 0 1.00 1.0]);
end

%%draw the complete image
curaxis = drawopt.curaxis;
axes(curaxis.frm);      
imagesc(frame, [0,1]); 
hold on;     

%%draw the tracking box
sz = size(tmpl.mean);  
if param.Flag == 1
    drawbox(sz, param.combineest, 'Color','r', 'LineWidth',2.5);
else
    drawbox(sz, param.est, 'Color','r', 'LineWidth',2.5);
end

%%display the frame number
text(5, 18, num2str(fno), 'Color','y', 'FontWeight','bold', 'FontSize',18);

axis equal tight off;
hold off;
drawnow; 