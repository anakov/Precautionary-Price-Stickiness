function Resid = dyneqkleinM(Y)

% Defines equations of stochastic model;
% Input: X: All variables, current and lagged
% Outputs: Equation residuals

global Params;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD parameters
 
beta = Params.beta; 
gamma = Params.gamma; 
chi = Params.chi; 
epsilon= Params.epsilon; 
mu = Params.mu; 
nu = Params.nu; 

Rss = Params.Rss; 
Cbar = Params.Cbar; 
phiPI = Params.phiPI; 
phiC = Params.phiC; 

adjtype = Params.adjtype; 
alpha = Params.alpha; 
lbar = Params.lbar; 
ksi = Params.ksi; 
noise = Params.noise; 
%eta = Params.eta; 

PMAT = Params.PMAT; 
sMAT = Params.sMAT; 
TRANSMAT = Params.TRANSMAT; 
Pgrid = Params.Pgrid; 
pstep = Params.pstep; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KLEIN setup:  X = [Pdist, DP, mlag, V, C, PI, m]
% z is the exogenous stochastic processes driving money and productivity, with z_t+1 = phiz z_t + iidshock
% PhiHatNow is dist at beginning of t before firms adjust AND before money shock z_t is realized.
% PhiHatNow_t = Phi_t-1 = end of period t-1 production distribution
% State variables are: today's shocks z, PhiHatNow, price dispersion, and lagged real money  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD VARIABLES 
  nPhi = Params.nPhi;
  nV = Params.nV;
  nsj = Params.nsj;
  nss = Params.nss;

% EXOGENOUS VARIABLES  
  znow = Y(Params.iz);       % exogenous shock process (possibly correlated)
  znext = Y(Params.iznext);  % ShockNow and ShockNext are scalars: no further extraction needed
  zRnow = znow(1);           % Money growth shock today
  zRnext = znext(1);         % Money growth shock tomorrow
  zAnow = znow(2);           % Common TFP shock

% ENDOGENOUS VARIABLES:
  xnow = Y(Params.ix);         % endogenous variables now
  xnext = Y(Params.ixnext);    % endogenous variables next
    
  % ENDOGENOUS STATE VARIABLES
  PhiHatNow = xnow(1:nPhi);
  PhiHatNext = xnext(1:nPhi);
  DPnow = xnow(nPhi+1);
  DPnext = xnext(nPhi+1);
  mlagnow = xnow(nPhi+2);
  mlagnext = xnext(nPhi+2);

  % ENDOGENOUS JUMP VARIABLES:
  Vnow = xnow(nPhi+nss+1:nPhi+nss+nV);
  Vnext = xnext(nPhi+nss+1:nPhi+nss+nV);
  Cnow = xnow(nPhi+nss+nV+1);
  Cnext = xnext(nPhi+nss+nV+1);
  PInow = xnow(nPhi+nss+nV+2);
  PInext = xnext(nPhi+nss+nV+2);
  mnow = xnow(nPhi+nss+nV+3);
  mnext = xnext(nPhi+nss+nV+3);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESHAPE VECTORS TO MATRICES size (nump,nums)
  [nump,nums]=size(PMAT);
  siz=[nump,nums];
  PhiHatNow = reshape(PhiHatNow,siz);
  PhiHatNext = reshape(PhiHatNext,siz);
  Vnow = reshape(Vnow,siz);
  Vnext = reshape(Vnext,siz);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE SOME VARIABLES USING EQUATIONS OUTSIDE OF KLEIN REPRESENTATION

% Nominal interest rate: from money demand equation
  inow = 1/(1 - nu*Cnow^gamma/mnow);

% Real wage: from Labor supply equation (detrended by P)
  wnow  = chi*Cnow^gamma; 
  wnext = chi*Cnext^gamma;
    
% Payoff today
  Unow = Cnow*(PMAT).^(-epsilon).*(PMAT - wnow*exp(-zAnow).*sMAT);   
  
% Calculate the transition matrices R (THE OFFSET IS DETERMINED BY PI NOW)
  Rnow  = Rmatrix(nump, PInow, pstep);
  Rnext = Rmatrix(nump, PInext, pstep);

  if adjtype>5
  % Calculate stochastic strategies logitprobMAT now and next
    logitpMATnow = logitprob(Vnow, noise, wnow);
    logitpMATnext = logitprob(Vnext, noise, wnext);
  % Calculate expected payoff EV now and next
    EVnow = sum(logitpMATnow.*Vnow);
    EVnext = sum(logitpMATnext.*Vnext);

    syntropyNow = ones(nump,1)*(log(nump) + sum(logitpMATnow.*log(max(logitpMATnow,eps^.5))));
    syntropyNext = ones(nump,1)*(log(nump) + sum(logitpMATnext.*log(max(logitpMATnext,eps^.5))));

  else
  % Get optimal value and optimal price now and next
    [EVnow, pStarNow]   = M_pStar(Vnow, Pgrid, PInow);
    [EVnext, pStarNext] = M_pStar(Vnext, Pgrid, PInext);
    syntropyNow = [];
    syntropyNext = [];
  end

  % Calculate adjustment values Dnow and Dnext
  Dnow  = ones(nump,1)*EVnow - Vnow;   
  Dnext = ones(nump,1)*EVnext - Vnext; 

  adjcostNow = cost(adjtype, alpha, noise, syntropyNow);
  adjcostNext = cost(adjtype, alpha, noise, syntropyNext);
  
% Calculate probabilities of adjustment Lambdanow and Lambdanext, and ExpectGAINSnext    
  LambdaNow = adjustment(adjtype, Dnow/wnow, ksi, alpha, lbar, adjcostNow);
  LambdaNext = adjustment(adjtype, Dnext/wnext, ksi, alpha, lbar, adjcostNext);
  
  ExpectGAINSnext = Vnext + (Dnext - wnext*adjcostNext).*LambdaNext;

% Calculate PhiTildeNow from PhiHatNow = Phi_t-1
  PhiTildeNow = Rnow*PhiHatNow*TRANSMAT';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE RESIDUALS FOR JACOBIAN

% PhiHatNext = dist of prices at time of production NOW (after shocks and adjustment)
  if adjtype>5
    PhiResid =-PhiHatNext + (1-LambdaNow).*PhiTildeNow + logitpMATnow.*(ones(nump,1)*sum(LambdaNow.*PhiTildeNow)); 
  else
    PmatNow = Pmatrix(pStarNow, Pgrid, pstep);
    PhiResid =-PhiHatNext + (1-LambdaNow).*PhiTildeNow + PmatNow.*(ones(nump,nump)*(LambdaNow.*PhiTildeNow)); 
  end
  
% Price dispersion dynamics  
  deltaResid = DPnext - sum(sum(PhiHatNext.*sMAT.*PMAT.^(-epsilon))); 
  
% Lagged real money level
  mlagResid = mlagnext - mnow;   

% Value function residual
  VResid = -Vnow + Unow + beta*(Cnext/Cnow)^(-gamma)*Rnext'*ExpectGAINSnext*TRANSMAT;
 
% Consumption Euler residual
  eulerResid = 1 - inow*beta*(Cnext/Cnow)^(-gamma)/PInext; 

% Aggregate price level residual
  priceResid = 1 - (sum(sum(PhiHatNext.*(PMAT.^(1-epsilon)))))^(1/(1-epsilon));
  
% Money growth process
  moneyGrowthresid = PInow*mnow/mlagnow/mu - exp(zRnow);   
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASSEMBLE RESID VECTOR:
  Resid = [PhiResid(:); deltaResid; mlagResid; VResid(:); eulerResid; priceResid; moneyGrowthresid];
% order of residuals is unimportant, but for simplicity follow same ordering
%   for residuals as for variables and equations
   
