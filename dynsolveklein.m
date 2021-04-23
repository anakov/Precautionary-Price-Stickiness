% Solves dynamic stochastic general equilibrium using Klein's method
% Taylor rule shock
% dynsolveklein.m calls dyneqklein.m, jacob_reiter.m, and kleinsolv.m.

global Params;
format long
jacstep = 100*tol;                        % size of step for numerical jacobian calculation
eqcutoff = 100*jacstep;                   % stable-unstable eigenvalue cutoff 

phiMAT   = [phiR 0; 0 phiA];              % Matrix of shock persistence parameters 

% X =[Pdist, DP, V, C, PI]
nsj = 2;                                  % number of scalar jump variables (C, PI)
nss = 1;                                  % number of scalar state variables (DP)
nz  = 2;                                  % number of exogenous shock processes (money, TFP)
nPhi = gridsize;                          % number of points of the distribution (states)
nV   = gridsize;                          % number of points of the value function (jumps)
Ntot = nPhi+nss+nV+nsj;                   % total number of variables            

% STORE VARIABLES IN PARAMS
Params.nsj = nsj;
Params.nss = nss;
Params.nz = nz;
Params.nPhi = nPhi;
Params.nV = nV; 

% Y WILL CONSIST OF FOUR PARTS
Params.ix     = 1:Ntot;                   % length Ntot
Params.ixnext = Ntot+1:2*Ntot;            % length Ntot
Params.iz     = 2*Ntot+1:2*Ntot+nz;       % length nz
Params.iznext = 2*Ntot+nz+1:2*Ntot+2*nz;  % length nz

Params.beta = beta; 
Params.gamma = gamma; 
Params.chi = chi; 
Params.epsilon= epsilon; 
Params.mu = mu; 
Params.nu = nu; 

Params.Rss = Rss; 
Params.Cbar = Cbar; 
Params.phiPI = phiPI; 
Params.phiC = phiC; 

Params.adjtype = adjtype; 
Params.alpha = alpha;          
Params.lbar = lbar; 
Params.ksi = ksi;              
Params.noise = noise;              

Params.PMAT = PMAT; 
Params.sMAT = sMAT; 
Params.TRANSMAT = TRANSMAT; 
Params.Pgrid = Pgrid; 
Params.pstep = pstep; 

Xss = [Pdist(:);WeightPriceDispers;V(:);Cbar;mu];    % X =[Pdist, DP, V, C, PI]
stst2=[Xss;Xss;zeros(nz,1);zeros(nz,1)];

resid = feval(@dyneqklein,stst2);
if(max(abs(resid))>tol || 10*max(abs(resid))>jacstep)
  disp('WARNING: Large residual at stst: max(abs(resid)) = ');
  disp(max(abs(resid)));
  keyboard
end;
tic
disp(sprintf('\n'))  
disp('START JACOBIAN CALCULATION')

   jac = jacobian(@dyneqklein,resid,stst2,jacstep);
   ajac = jac(:,Params.ixnext);
   bjac = jac(:,Params.ix);
   cjac = jac(:,Params.iznext);
   djac = jac(:,Params.iz);

disp(sprintf('\n'))  
disp('START KLEIN SOLUTION')

[JUMPS,STATEDYNAMICS,stableeigs,unstableeigs] = kleinsolve(ajac,bjac,cjac,djac,phiMAT,nPhi+nss,eqcutoff);
clear jac ajac bjac cjac djac