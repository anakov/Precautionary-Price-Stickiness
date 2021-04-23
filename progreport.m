% Reports convergence statistics

function Y = progreport(adjtype,finegrid,fzeroiter,VDIFF,Viter) 
clc
disp(sprintf('Model      : %d',adjtype))
disp(sprintf('Grid type  : %d',finegrid))
disp(sprintf('\n'))  
disp(sprintf('Fzero iter : %d',fzeroiter))
disp(sprintf('V DIFF     : %0.3d',VDIFF))
disp(sprintf('V iter     : %d',Viter))
Y=[];