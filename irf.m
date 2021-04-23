% Computes impulse-response functions

clear STATEHISTORY; clear JumpHistory 
fprintf('\n')  
TT = 20;              %periods 1:19 fit nicely in graph 0:20
INITCONDIT=0;
%load GE_ss;

% SET INTEREST RATE IMPULSES
time1Rshock = 0;
time2Rshock = jacstep; % shock should be approx size of jacstep to preserve linearity in aggregate shocks
time3Rshock = 0;

% SET TFP IMPULSES
time1TFPshock = 0;
time2TFPshock = 0;
time3TFPshock = 0;

% SPECIFY MONEY SHOCK PROCESS for periods 1:TT
Rshocks   = [time1Rshock   time2Rshock   time3Rshock   zeros(1,TT-3)];  % 3 shocks + zeros
TFPshocks = [time1TFPshock time2TFPshock time3TFPshock zeros(1,TT-3)];  % 3 shocks + zeros

shocktime = 2;

if Rshocks(shocktime)>0
   scalefactor = abs(1/Rshocks(shocktime));    
elseif TFPshocks(shocktime)>0
   scalefactor = abs(1/TFPshocks(shocktime));  
end

distsim
if phiPI > 0, computeirf; else  computeirfM; end    % run Taylor rule or money growth shock
plotirf
