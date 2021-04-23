% Gets value function by iteration on discrete grid
% version 17 april 2008
global fzeroiter 
VDIFF=inf;                                                 % reset difference in value function
Viter=0;                                                   % reset counter
fzeroiter=fzeroiter+1;

while VDIFF>tol && Viter<10000                             % iterate to convergence of V 
  Viter=Viter+1;                                           % increment counter
  if rem(Viter,100)==0  && showconverge                     % report convergence progress
     progreport(adjtype,finegrid,fzeroiter,VDIFF,Viter); 
  end

% Time t+1 values
  if adjtype>5
     logitprobMAT = logitprob(V, noise, wbar);
     EV = sum(logitprobMAT.*V);
     syntropy = ones(nump,1)*(log(nump) + sum(logitprobMAT.*log(max(logitprobMAT,eps^.5))));
  else 
     [EV, pstar] = M_pStar(V, Pgrid, mu);                 % quadratic value function interpolation 
     syntropy = [];
  end
  
  D = ones(nump,1)*EV - V;                                % D is the expected gain from adjustment (can be negative)
  Dopt = ones(nump,1)*max(V) - V;                         % Dopt is the gain from adjustment to rational optimum
 
  adjcost = cost(adjtype, alpha, noise, syntropy);
  lambda = adjustment(adjtype, D/wbar, ksi, alpha, lbar, adjcost);
  
  EXPGAINS = V + (D - wbar*adjcost).*lambda;
  
% Time t values
  iterV = PAYOFFMAT + beta*RECURSEMAT'*EXPGAINS*TRANSMAT;  % iterV is current payoff plus disc. continuation value
  VdifMin = min(min(iterV-V));                             % minimum difference 
  VdifMax = max(max(iterV-V));                             % maximum difference
  VDIFF = VdifMax-VdifMin;                                 % distance between max and min difference
 % VDIFF = max(max(abs(iterV-V)));                       % change in value function (sup norm)
  V = iterV;                                             % updating V
end
 V = V + beta/(1-beta)*(VdifMax+VdifMin)/2;              % vertical shift of value function once shape has converged

