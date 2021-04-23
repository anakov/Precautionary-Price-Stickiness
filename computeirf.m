% Computes dynamic paths as a function of initial state and exogenous shocks
% In particular computes impulse-response functions
% Taylor rule shocks
% For simplicity, 'time' is same as vector index (i.e. starts at time=1)

% IN ORDER TO BE ABLE TO CONSIDER VERY SMALL SHOCKS, COMPUTE DEVIATIONS ONLY

% EXTRACTING VARIABLES DIRECTLY FROM KLEIN REPRESENTATION
% Pdist (lagged), V, C, PI

% Extract shocks
  d_R_path = STATEHISTORY(1,:);                                            % interest rate shock
  d_A_path = STATEHISTORY(2,:);                                            % TFP shock

% Extract distributional dynamics  
  d_PhiHat_path = STATEHISTORY(nz+1:end-1,:);                              % history of LAGGED distributions
  PhiHat_path = Pdist(:)*ones(1,TT) + d_PhiHat_path;                       % by definition, PhiHat_t = Phi_t-1
  
  d_delta_wedge = STATEHISTORY(end,:);                                     % history of price dispersion
  delta_wedge = WeightPriceDispers + d_delta_wedge(2:end);                 % delta_wedge(t+1) is today's
                                                                           
% Extract components from DYNAMICS OF JUMPS:
  d_V_path = JumpHistory(1:nV,:);                                          % value function history
  V_path = V(:)*ones(1,TT) + d_V_path;          

  d_C_path = JumpHistory(nV+1,:);                                          % consumption history
  C_path = Cbar + d_C_path;                                                

  d_PI_path = JumpHistory(nV+2,:);                                         % inflation history
  PI_path = mu + d_PI_path; 

% CONSTRUCT OTHER VARIABLES NOT INCLUDED IN KLEIN REPRESENTATION
% Nominal interest rate: from Taylor rule
  R_path = Rss + phiPI*(PI_path-mu) +  phiC*(C_path-Cbar) + d_R_path;
  R_path_a = R_path.^12 - 1;                                               % annualized net nominal interest rate 

% Real money balances: from Money demand equation
  m_path = nu*C_path.^gamma./(1-1./R_path);  
  p_path = 1./m_path;

% Real wage: from Labor supply equation (detrended by P)
  w_path  = chi*C_path.^gamma; 

% Labor
  labor_path = d_C_path + d_delta_wedge - d_A_path + Nbar;

% Stochastic strategies and expected value
  logitprobMAT_path = logitprob(V_path, noise, wbar);
  EV_path = sum(logitprobMAT_path.*V_path);
  
% Adjustment gain and adjustment probability  
  D_path = ones(rows(V_path),1)*EV_path - V_path;
 
  syntropy_path = ones(nump,1)*(log(nump) + sum(logitprobMAT_path.*log(max(logitprobMAT_path,eps^.5))));
  adjcost_path = cost(adjtype, alpha, noise, syntropy_path);
  Lambda_path = adjustment(adjtype, D_path./(ones(gridsize,1)*w_path), ksi, alpha, lbar, adjcost_path);

% Constructing PhiTilde (beginning-of-t distributions) from PhiHat (lagged distributions)
  PhiTilde_path = NaN*zeros(gridsize,TT);         
  for time=1:TT
      Rnow = Rmatrix(nump, PI_path(time), pstep);
      PhiTildeNow = Rnow*reshape(PhiHat_path(:,time),nump,nums)*TRANSMAT';
      PhiTilde_path(:,time)= PhiTildeNow(:);       % PdistEroded history
  end

% Now that we have constructed PhiTilde, we no longer need PhiHat.
  Phi_path = PhiHat_path;
  Phi_path(:,1) = [];  % here we are losing 1 period for Phi and everything computed from Phi
% So now we have history of Phi_t = distribution at time of production in period t.

% Compute mass of adjusters and fraction of adjusting firms
  Adjusters_path = Lambda_path.*PhiTilde_path;
  frac_adjusters_path = sum(Adjusters_path);

  ex_ante_real_interest_rate = R_path(1:end-1)-PI_path(2:end)-(Rss-mu);
  if INITCONDIT==0
    % the time 2 money shock is unexpected in period 1, so expected inflation equals steady-state
      ex_ante_real_interest_rate = [0 ex_ante_real_interest_rate(2:end)]; 
  end

% % prepare matrices for inflation decomposition
% Pchanges_path  = NaN*ones(nump,nums,TT); % needed for inflation decomposition later
% AvPchange_path = NaN*ones(1,TT);         % needed for inflation decomposition later
% for time=1:TT
%   Pchanges_path(:,:,time) = ones(nump,1)*pStars_path(time,:) - Pgrid*ones(1,nums);
%   AvPchange_path(time) = sum(sum(reshape(Pchanges_path(:,:,time),nump,nums)...
%                           .*reshape(Adjusters_path(:,time),nump,nums)))./frac_adjusters_path(time);
% end
%   
% % inflation decomposition
% intensive_margin_path = zeros(1,TT-1); 
% extensive_margin_path = zeros(1,TT-1);  
% selection_effect_path = zeros(1,TT-1); 
% for time=1:TT
%   infdecomp;
%   intensive_margin_path(time) = intensive_margin; 
%   extensive_margin_path(time) = extensive_margin;  
%   selection_effect_path(time) = selection_effect; 
% end


