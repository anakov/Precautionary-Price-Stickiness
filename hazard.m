function [hazd, masspchangesMAT] = hazard(horizon, RECURSEMAT, Pdist, TRANSMAT, logitprobMAT, lambda)
% Computes the hazard function and the size distribution of price changes after an initial adjustment
% hazd(k) = freqadjusters(k)/densitySurvivors(k-1) 
% conditional on all firms having adjusted at time 0

[nump, nums] = size(Pdist);
masspchangesMAT = NaN*zeros(2*nump-1,horizon);

% period 0, forcing price adjustment from steady-state
PDE = RECURSEMAT*Pdist*TRANSMAT';                              % distribution after productivity shock and deflation
SurvivorMAT = logitprobMAT.*(ones(nump,1)*sum(lambda.*PDE));   % distribution of adjusters after adjustment
survivors(1) = sum(sum(SurvivorMAT));                          % survivors at time 0 is everybody who adjusted at 0

% periods from 1 onwards: keeping track of survivors only
for k=2:horizon+1
 PDE = RECURSEMAT*SurvivorMAT*TRANSMAT';                       % distribution after productivity shock and deflation
 ADJ = lambda.*PDE;                                            % adjusters at k
 SurvivorMAT = (1-lambda).*PDE;                                % distribution of survivors at k 

 fadj(k) = sum(sum(ADJ));                                      % density of adjusters at k 
 survivors(k) = sum(sum(SurvivorMAT));                         % density of survivors at k
 
 hazd(k) = fadj(k)/survivors(k-1);                             % hazard at k 
 masspchangesMAT(:,k-1) = histpchanges(ADJ,logitprobMAT);      % mass of price changes
end

hazd = hazd(2:end);
