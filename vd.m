clear STATEHISTORY; clear JumpHistory 
% Computes variance decomposition and Phillips curve regression

disp(sprintf('\n'))  
TT = 3*33;      % stochastic simulation 
INITCONDIT=0;

% SPECIFY MONEY SHOCK PROCESS for periods 1:TT
randn('state',0)
shocksize = jacstep;
scalefactor = 1/shocksize;
Rshocks = [shocksize *randn(1,TT)];  %#ok<NBRAK> %simulating random history
time1Rshock = Rshocks(1);

TFPshocks = zeros(1,TT);
time1TFPshock = TFPshocks(1);

distsim;
if phiPI < 0, computeirf; else  computeirfM; end    % run Taylor rule or money growth shock

if rem(TT,3)==0 
    
% convert to quarterly frequency
  C_pathQ = mean(reshape(C_path,3,TT/3));
  PI_pathQ = mean(reshape(PI_path,3,TT/3));
  d_R_pathQ = mean(reshape(d_R_path,3,TT/3));
  
  pchCQ = C_pathQ(2:end)./C_pathQ(1:end-1)-1;

% gdp growth and delfator inflation quarterly s.d. during 1984-2008
  data_V_cons_growth = 0.00510;  % okay:  cgg_mpr_qje.wf1
  data_V_infl        = 0.00246;  % okay:  cgg_mpr_qje.wf1 

  scaleUp = data_V_infl/std(PI_pathQ);          % scale up to explain all observed inflation
  
  std_PI_pathQ  = std(PI_pathQ)*scaleUp;
  std_pchCQ     = std(pchCQ)*scaleUp;

  VD_inflation   = std_PI_pathQ/data_V_infl  ;  % equals 1 by construction
  VD_cons_growth = std_pchCQ/data_V_cons_growth ;  
  
% 2SLS regression of consumption on inflation     
% first stage regression: inflation on exogenous shock 
  regressors = [ones(size(d_R_pathQ')) d_R_pathQ'];
  if rank(regressors)==size(regressors,2);
     [B,BINT,R,RINT,STATS] = regress(PI_pathQ',regressors);
  else
     error('Colinear regressors');
  end
  PI_projQ = B(1) + B(2)*regressors(:,2);
  
% second stage regression: output on predicted inflation     
  regressors = [ones(size(PI_projQ)) 4*log(PI_projQ)];
  if rank(regressors)==size(regressors,2);
     [B,BINT,R,RINT,STATS] = regress(log(C_pathQ'),regressors );
  else
     error('Colinear regressors');
  end

  
% Print output
  disp(sprintf('100 x std dev of money shock: %0.3g',100*std(Rshocks)*scaleUp))
  disp(sprintf('\n')) 
  disp(sprintf('Model implied 100 x std of quarterly inflation             : %0.3g',100*std_PI_pathQ))
  disp(sprintf('Actual 100 x std of quarterly deflator inflation 1984-2008 : %0.3g',100*data_V_infl))
  disp(sprintf('Share of inflation variance due to money growth shocks     : %0.3g%%', 100*VD_inflation))
  disp(sprintf('\n')) 
  disp(sprintf('Model implied 100 x std of quarterly output growth         : %0.3g',100*std_pchCQ))
  disp(sprintf('Actual 100 x std of quarterly output growth 1984-2008      : %0.3g',100*data_V_cons_growth ))
  disp(sprintf('Share of output variance due to money growth shocks        : %0.3g%%', 100*VD_cons_growth))
  disp(sprintf('\n')) 
  disp(sprintf('Phillips curve: log(C_pathQ) = alpha + beta(4log(PI_projQ))'))
  disp(sprintf('Data frequency: quarterly (average of monthly simulated observations)'))
  disp(sprintf('Estimation method: 2SLS'))
  disp(sprintf('Instrument for inflation: exogenous aggregate shock'))
  disp(sprintf('\n')) 
  disp(sprintf('Slope coefficient beta                                     : %0.3g', B(2)))
  disp(sprintf('Standard error for slope coefficient                       : %0.3g', abs(B(2)-BINT(2,1))/2))
  disp(sprintf('R2 of regression                                           : %0.3g', STATS(1)))
  disp(sprintf('\n')) 
end
