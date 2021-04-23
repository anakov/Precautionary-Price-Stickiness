function Resid = dyneqklein(Y)
% Defines equations of stochastic model
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

PMAT = Params.PMAT; 
sMAT = Params.sMAT; 
TRANSMAT = Params.TRANSMAT; 
Pgrid = Params.Pgrid; 
pstep = Params.pstep; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KLEIN setup: X=[Pdist, DP, V, C, PI]
% z is the exogenous stochastic processes driving money and productivity, with z_t+1 = phiz z_t + iidshock
% PhiHatNow is dist at beginning of t before firms adjust AND before money shock z_t is realized.
% PhiHatNow_t = Phi_t-1 = end of period t-1 production distribution
% State variables are: today's shocks z and PhiHatNow  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD VARIABLES 
  nPhi = Params.nPhi;
  nV = Params.nV;
  nsj = Params.nsj;
  nss = Params.nss;

% EXOGENOUS VARIABLES  
  znow = Y(Params.iz);       % exogenous shock process (possibly correlated)
  znext = Y(Params.iznext);  % ShockNow and ShockNext are scalars: no further extraction needed
  zRnow = znow(1);           % Taylor rule shock today
  zRnext = znext(1);         % Taylor rule shock tomorrow
  zAnow = znow(2);           % Common TFP shock

% ENDOGENOUS VARIABLES:
  xnow = Y(Params.ix);         % endogenous variables now
  xnext = Y(Params.ixnext);    % endogenous variables next
    
  % ENDOGENOUS STATE VARIABLES
  PhiHatNow = xnow(1:nPhi);
  PhiHatNext = xnext(1:nPhi);
% DPnow = xnow(nPhi+1);
  DPnext = xnext(nPhi+1);

  % ENDOGENOUS JUMP VARIABLES:
  Vnow = xnow(nPhi+nss+1:nPhi+nss+nV);
  Vnext = xnext(nPhi+nss+1:nPhi+nss+nV);
  Cnow = xnow(nPhi+nss+nV+1);
  Cnext = xnext(nPhi+nss+nV+1);
  PInow = xnow(nPhi+nss+nV+2);
  PInext = xnext(nPhi+nss+nV+2);
  
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
% Nominal interest rate: from Taylor rule
  inow = Rss + phiPI*(PInow-mu) + phiC*(Cnow-Cbar) + zRnow;

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
  logitprobMATnow = logitprob(Vnow, noise, wnow);
  logitprobMATnext = logitprob(Vnext, noise, wnext);

% Calculate expected payoff EV now and next
  EVnow = sum(logitprobMATnow.*Vnow);
  EVnext = sum(logitprobMATnext.*Vnext);

% Syntropy measure
  syntropyNow = ones(nump,1)*(log(nump) + sum(logitprobMATnow.*log(max(logitprobMATnow,eps^.5))));
  syntropyNext = ones(nump,1)*(log(nump) + sum(logitprobMATnext.*log(max(logitprobMATnext,eps^.5))));
else
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
  
% Calculate matrix P indicating the split of adjusting firms' 
% mass between adjacent grid points around the optimal price  
%  PmatNow = Pmatrix(pStarNow, Pgrid, pstep);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE RESIDUALS FOR JACOBIAN

% PhiHatNext = dist of prices at time of production NOW (after shocks and adjustment)
PhiResid = -PhiHatNext + (1-LambdaNow).*PhiTildeNow + logitprobMATnow.*(ones(nump,1)*sum(LambdaNow.*PhiTildeNow)); 
   
% Value function residual
VResid = -Vnow + Unow + beta*(Cnext/Cnow)^(-gamma)*Rnext'*ExpectGAINSnext*TRANSMAT;
 
% Consumption Euler residual
eulerResid = 1 - inow*beta*(Cnext/Cnow)^(-gamma)/PInext; 

% Aggregate price level residual
priceResid = 1 - (sum(sum(PhiHatNext.*(PMAT.^(1-epsilon)))))^(1/(1-epsilon));
  
% Price dispersion dynamics  
deltaResid = DPnext - sum(sum(PhiHatNext.*sMAT.*PMAT.^(-epsilon))); 
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASSEMBLE RESID VECTOR:
Resid = [PhiResid(:); VResid(:); eulerResid; priceResid; deltaResid];
% order of residuals is unimportant, but for simplicity follow same ordering
%   for residuals as for variables and equations
   
