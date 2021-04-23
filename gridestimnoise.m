% Estimates the model's parameters from data on price changes
clear; clc; tic
global noise
set(0,'DefaultFigureWindowStyle','normal')  % undock all figures
load acnielsen

% same productivity as estimated SSDP
param; adjtype = 3; version = 1; adjparams; gridSpread=0; makegrids;
lbound = 2*PMIN+pstep/2; hbound = 2*PMAX-pstep/2; 
Pchangegrid=(2*PMIN:pstep:2*PMAX)';
edges  = [-inf linspace(lbound,hbound,length(Pchangegrid)-1) inf];  % same bin edges as in calcstats

pdfdata = histc(data,edges);
pdfdata = pdfdata(1:end-1);      % the last bin counts any values that match EDGES(end); see help histc
pdfdata = pdfdata./sum(pdfdata);

noise_dist = [NaN;NaN;NaN;NaN];
% noisegrid = [0.0002 0.001 0.005 0.01 0.05 0.1 0.2 0.4 0.6 0.8 1 1.1 1.2 1.3 1.4 1.5 2 3 5 10];
noisegrid = [0.019 0.02 0.021 0.022 0.02384];
version = 3; rho   =  0.88115;  stdMC =  0.14742;  

disp('Grid based estimation of noise parameter. This takes a while...')
for noise = noisegrid
 noise   
 run;
 dist = norm(freqnonzeropchanges-0.205);  % + norm(denspchanges-pdfdata);        
% dist1 = length(denspchanges)*norm(freqnonzeropchanges-0.205);
% dist2 = norm(denspchanges-pdfdata);        
 noise_dist = [noise_dist [noise; dist;]];   % dist1; dist2]]
 save noisest noise_dist; 
end
[m, i] = min(noise_dist(2,:));
disp(sprintf('Noise: %0.4g  Distance: %0.4g  Freq comp: %0.4g  Dens. comp: %0.4g', noise_dist(:,i)))
plot(noise_dist(1,:),noise_dist(2:end,:))