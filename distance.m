function out = distance(in)
% Computes distance criterion for estimation

global noise alpha lbar

noise = in(1);
lbar  = in(2);

gess;
%out = length(denspchanges)*norm(freqnonzeropchanges-0.10); %+ norm(denspchanges-pdfdata);        
out = length(denspchanges)*norm(freqnonzeropchanges-0.10) + norm(denspchanges-pdfdata);         
