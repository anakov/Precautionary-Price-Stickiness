% Computes dynamic paths as a function of initial state and exogenous shocks
% In particular computes impulse-response functions
% Money growth shocks
% For simplicity, 'time' is same as vector index (i.e. starts at time=1)

% IN ORDER TO BE ABLE TO CONSIDER VERY SMALL SHOCKS, COMPUTE DEVIATIONS ONLY

% EXTRACTING VARIABLES DIRECTLY FROM KLEIN REPRESENTATION
% X = [Pdist, DP, mlag, V, C, PI, m]

% Extract exogenous shocks processes from STATEHISTORY
  d_R_path = STATEHISTORY(1,:);                                            % money growth process
  d_A_path = STATEHISTORY(2,:);                                            % TFP process

% Extract state dynamics from STATEHISTORY
  d_PhiHat_path = STATEHISTORY(nz+1:end-2,:);                              % history of LAGGED distributions
  PhiHat_path = Pdist(:)*ones(1,TT) + d_PhiHat_path;                       % by definition, PhiHat_t = Phi_t-1
  
  d_delta_wedge = STATEHISTORY(end-1,:);                                   % history of price dispersion
  delta_wedge = WeightPriceDispers + d_delta_wedge(2:end);                 % delta_wedge(t+1) is today's
  
  d_mlag_path = STATEHISTORY(end,:);                                       % history of lagged real money
  mlag_path = mbar + d_mlag_path ;                        
                                                                           
% Extract jump dynamics from JumpHistory
  d_V_path = JumpHistory(1:nV,:);                                          % value function history
  V_path = V(:)*ones(1,TT) + d_V_path;          

  d_C_path = JumpHistory(nV+1,:);                                          % consumption history
  C_path = Cbar + d_C_path;                                                

  d_PI_path = JumpHistory(nV+2,:);                                         % inflation history
  PI_path = mu + d_PI_path; 
  
  d_m_path = JumpHistory(nV+3,:);                                          % real money history
  m_path = mbar + d_m_path; 

% CONSTRUCT OTHER SCALAR VARIABLES NOT INCLUDED IN KLEIN REPRESENTATION

% Nominal interest rate: from Taylor rule
  R_path = 1./(1 - nu*C_path.^gamma./m_path);
  R_path_a = R_path.^12 - 1;      % annualized net nominal interest rate 

% Ex-ante real interest rate  
ex_ante_real_interest_rate = R_path(1:end-1)-PI_path(2:end)-(Rss-mu);
if INITCONDIT==0
% time 2 shock is unexpected in time 1, so expected inflation is st.state
   ex_ante_real_interest_rate = [0 ex_ante_real_interest_rate(2:end)]; 
end

% Real wage: from Labor supply equation (detrended by P)
  w_path  = chi*C_path.^gamma; 

% Labor hours path
  labor_path = C_path(1:end-1).*delta_wedge./exp(d_A_path(1:end-1));

% Nominal money growth path
  mu_path = PI_path.*m_path./mlag_path;

  
% COSTRUCT MATRICES NOT INCLUDED IN KLEIN REPRESENTATION

intensive_path = NaN*zeros(1,TT);
extensive_path = NaN*zeros(1,TT);
selection_path = NaN*zeros(1,TT);
error_path = NaN*zeros(1,TT);
Pchanges_path  = NaN*ones(nump,nums,TT);     
PhiTilde_path  = NaN*zeros(gridsize,TT);         
frac_adjusters_path = NaN*zeros(1,TT);
desiredadj_path = NaN*zeros(1,TT);
desiredinflation_path = NaN*zeros(1,TT);
timecosts_path = NaN*zeros(1,TT);
adjcosts_path = NaN*zeros(1,TT);

for time=1:TT
    Rnow = Rmatrix(nump, PI_path(time), pstep);
    Vnow = reshape(V_path(:,time),nump,nums);
    wnow = w_path(time);
    
    % Constructing PhiTilde (beginning-of-t distributions) from PhiHat (lagged distributions)
    PhiTildeNow = Rnow*reshape(PhiHat_path(:,time),nump,nums)*TRANSMAT';
    PhiTilde_path(:,time)= PhiTildeNow(:);      
    
    if  adjtype>5
          % Stochastic strategies and expected value
        logitprobMATnow = logitprob(Vnow, noise, wnow);
        EVnow = sum(logitprobMATnow.*Vnow);
        Dnow = ones(rows(Vnow),1)*EVnow - Vnow;
        [pstarprob, pstarindex] = max(logitprobMATnow);
        pstarsnow = Pgrid(pstarindex)';
        syntropynow = ones(nump,1)*(log(nump) + sum(logitprobMATnow.*log(max(logitprobMATnow,eps^.5))));
    else  % Get optimal value function and optimal price
        [Mnow pstarsnow] = M_pStar(Vnow, Pgrid, PI_path(time));
        Dnow = ones(nump,1)*Mnow - Vnow;
        syntropynow = [];
    end
    
  Pchanges_path(:,:,time) = ones(nump,1)*pstarsnow - Pgrid*ones(1,nums);
   
% Adjustment probabilities

  adjcostnow = cost(adjtype, alpha, noise, syntropynow);
  Lambdanow = adjustment(adjtype, Dnow/wnow, ksi, alpha, lbar, adjcostnow);

% Compute mass of adjusters and fraction of adjusting firms
  Adjustersnow = Lambdanow.*PhiTildeNow;
  frac_adjusters_path(time) = sum(sum(Adjustersnow));
      
  infdecomp;
  intensive_path(time) = intensive_margin ; 
  extensive_path(time) = extensive_margin ; 
  selection_path(time) = dPI_dmu - extensive_margin - intensive_margin ;
  
 end

  
% Now that we have constructed PhiTilde, we no longer need PhiHat.
%  Phi_path = PhiHat_path;
%  Phi_path(:,1) = [];  % here we are losing 1 period for Phi and everything computed from Phi
% So now we have history of Phi_t = distribution at time of production in period t.


  