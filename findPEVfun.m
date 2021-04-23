% Finds partial equilibrium steady-state value function
% for a given wage "wbar"
global alpha noise lbar

param;                                                       % load macro parameters 
adjparams;                                                   % load idiosyncratic shock and adjustment parameters
makegrids;                                                   % make price and cost grids
setmat;                                                      % construct payoff and value matrices

V = Vflex;                                                   % intial guess for value function
Cbar = (wbar/chi)^(1/gamma);                                 % compute Cbar based on candidate wage "wbar"
PAYOFFMAT = Cbar*PMAT.^(-epsilon).*(PMAT-wbar*sMAT);         % compute payoff matrix 
%PAYOFFMAT = Cbar*sMAT.^(epsilon-1).*PMAT.^(-epsilon).*(PMAT-wbar*sMAT);         % compute payoff matrix 
V_iter;                                                      % get value function given Cbar, wbar and PAYOFFMAT