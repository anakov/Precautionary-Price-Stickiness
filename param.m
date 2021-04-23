% Sets program execution and macro parameters

% PROGRAM EXECUTION PARAMETERS           
  adjtype      = 7;               % 1-SSDP; 2-Calvo; 3-FMC; 4-Woodford; 6-PPS; 7-ENT; 8-Nested logit;
  version      = 1;               % program version: set 3 to estimate the model. Set 1 for calibrated parameters
  finegrid     = 0;               % choose fine (1) or coarse (0) grid
  accuracy     = 1;               % controls residual tolerance. Use 1 or more for dynamics
  showconverge = 1*(version<3);   % show convergence progress. Set to 0 when estimating (version 3)
  idioshocks   = 1;               % heterogeneity: 1-idio shocks; 0-fixed heterogeneity; -1 rep. agent
  
% AGGREGATE SHOCK AND POLICY PARAMETERS  
  mu    = infparam('1');          % long-run gross inflation target (check infparam.m for available options)
  phiR  = 0.8;                    % persistence of money growth or Taylor rule shock
  phiPI = 0;                      % inflation response coefficient in Taylor rule (set to 0 for money rule)
  phiC  = 0;                      % output response coefficient in Taylor rule
  phiA  = 0;                      % persistence of aggregate technology shock 
  
% DISCOUNT AND PREFERENCE PARAMETERS     
  beta    = 1.04^(-1/12);         % time discount factor
  gamma   = 2;                    % CRRA coefficient
  chi     = 6;                    % labor supply parameter
  nu      = 1;                    % money demand parameter
  epsilon = 7;                    % elasticity of substitution among product varieties
  
% CONVERGENCE TOLERANCE LEVELS           
  tol = eps^.5/10^accuracy;       % convergence tolerance for Pidentity.m, V_iter.m, and Pdist_iter.m 

% INITIAL GUESS FOR REAL WAGE
  wflex = (epsilon-1)/epsilon;    % initial guess for real wage: flex-price, representative agent