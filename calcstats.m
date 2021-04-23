% Computes steady-state statistics and objects

% CHECK IF THE STEADY-STATE DISTRIBUTION IS WELL INSIDE THE GRID
boundhits = sum(Pdisteroded(end,1:end))+ sum(Pdisteroded(1,1:end))+ ...
             sum(Pdisteroded(1:end,end))+ sum(Pdisteroded(1:end,1)); % firms hitting boundaries of grid
if idioshocks>-1 && boundhits  > 0.015
   fprintf('Warning: %0.2g percent of firms hit grid boundaries after shock.',100*boundhits)
end

% VECTORIZING MATRICES
vecPdist=Pdist(:);                                                   
vecPdisteroded=Pdisteroded(:);                                       

% STEADY-STATE OF SOME MACRO VARIABLES
PI_SS  = mu-1;                                                       % inflation
Rbar   = (1 - nu*Cbar.^gamma).^(-12)-1;                              % annual net nominal interest rate
Rss    = mu/beta;                                                    % monthly gross nominal interest rate
mbar   = nu*Cbar^gamma/(1-1/Rss);                                    % average money holdings
Nbar   = Cbar*sum(sum(Pdist.*sMAT.*PMAT.^(-epsilon)));               % aggregate hours
U      = Cbar^(1-gamma)/(1-gamma) - chi*Nbar + nu*log(mbar);         % steady-state utility level

% HAZARD RATE AND HISTOGRAM OF PRICE CHANGES COMPUTATION
horizon = 18;                                                        % horizon in months for hazard calculation
masspchanges = ...
    histpchanges(lambda.*(RECURSEMAT*Pdist*TRANSMAT'),logitprobMAT); % get histogram of price changes
[hazd, masspchangesMAT] = ...                                        % get hazard f-n and histograms
    hazard(horizon, RECURSEMAT, Pdist, TRANSMAT, logitprobMAT, lambda);
denspchanges = masspchanges/sum(masspchanges);                       % density of price changes in steady-state
Pchangegrid=(2*PMIN:pstep:2*PMAX)';                                  % grid of price changes
denspchangesMAT = masspchangesMAT./...
    (ones(size(Pchangegrid))*sum(masspchangesMAT));                  % density of price changes after shock

% FREQUENCY OF NON-ZERO PRICE CHANGES, PRICE INCREASES, AND DECREASES
freqpchanges = sum(masspchanges);                                    % steady-state frequency of all price changes
freqzeropchanges = masspchanges(nump);                               % mass of zero price changes in middle bin
freqnonzeropchanges = freqpchanges-freqzeropchanges;                 % mass of non-zero price changes
freqpincreases = sum(masspchanges(nump+1:end));                      % mass of price increases
freqpdecreases = sum(masspchanges(1:nump-1));                        % mass of price decreases

% FRACTIONS OF PRICE INCREASES, DECREASES, AND SMALL PRICE CHANGES
fracPriceIncr = freqpincreases/freqnonzeropchanges;
fracPriceDecr = freqpdecreases/freqnonzeropchanges;
fracSmallChanges = (sum(masspchanges(abs(Pchangegrid)<=0.05+eps^.5))-freqzeropchanges)/freqnonzeropchanges;
fracSmallChanges25 = (sum(masspchanges(abs(Pchangegrid)<=0.025+eps^.5))-freqzeropchanges)/freqnonzeropchanges;

% MEAN PRICE CHANGE, MEAN PRICE INCREASE AND DECREASE
EPchange=(mu-1)/freqnonzeropchanges;                                 % mean price change: Pchangegrid'*denspchanges
EPincrease=Pchangegrid(nump+1:end)'*masspchanges(nump+1:end)...
    /freqpincreases;                                                 % mean price increase
EPdecrease=Pchangegrid(1:nump-1)'*masspchanges(1:nump-1)...
    /freqpdecreases;                                                 % mean price decrease

% DISPERSION MEASURES OF PRICE CHANGES
MeanAbsPchange=abs(Pchangegrid')*denspchanges;                       % mean absolute price change
MeanAbsPchangeTime=abs(Pchangegrid')*denspchangesMAT;                % mean abs P change as f-n of time since adj
StdPchanges=sqrt((Pchangegrid'-EPchange).^2*denspchanges);           % standard deviation of price changes
KurtPchanges=((Pchangegrid'-EPchange).^4*denspchanges)/...
                        StdPchanges^4;                               % kurtosis of price changes

% MEADIAN ABSOLUTE PRICE CHANGE, INCREASE, DECREASE
% NOT DONE YET FOR PPS
% density = denspchanges(nump+1:end) + denspchanges(nump-1:-1:1);  
% AbsPchange_density=[Pchangegrid(nump+1:end) density];              % matrix with abs p changes and their density
% MedAbsPchange=AbsPchange_density(find(cumsum(AbsPchange_density(:,2))>=.5,1),1); % median abs price change


% PRICES: MEAN AND DISPERSION MEASURES
ElogPrice=sum(log(PMAT(:)).*Pdist(:));                               % mean log-level price (NOT D-S AGGREGATE)
VarPrice=sum((log(PMAT(:))-ElogPrice).^2.*Pdist(:));                 % std of prices (levels)
stdPrice = sqrt(VarPrice);
ElogCost= sum(log(sMAT(:)).*Pdist(:));   
VarCost=sum((log(sMAT(:))-ElogCost).^2.*Pdist(:));
stdCost = sqrt(VarCost);
PriceDispersion=sum(sum( PMAT.^(-epsilon).*Pdist ));                 % Dixit-Stiglitz price dispersion measure
WeightPriceDispers=sum(sum(sMAT.*(PMAT.^(-epsilon)).*Pdist ));       % Productivity-weighted D-S dispersion      

% MENU COST FLOW                                                     % flow is freqpchanges*alpha*wbar
AvRevenue = sum(sum(Cbar*PMAT.^(1-epsilon).*Pdist));                 % average (and total) firms' revenue
if exist('alpha','var')                                              % as share of:    
   McostinRev=100*freqpchanges*alpha*wbar/AvRevenue;                 %  the flow of revenue of all firms
   McostinWageBill=100*freqpchanges*alpha*wbar/(Nbar*wbar);          %  the total wage bill 
   McostinCbar=100*freqpchanges*alpha/Cbar;                          %  consumption (units?)
end

% CROSS-SECTIONAL VARIANCE OF ADJUSTMENT PROBABILITIES
varlambda=sum(sum((lambda-freqpchanges).^2.*Pdisteroded));           % Cross-sectional variance of lambda   
CalvoMenuMetric=varlambda/(freqpchanges*(1-freqpchanges));           % Compute Calvo-Menu cost metric

% ADJUSTMENT HISTOGRAM (based on Pdisteroded)
edges=linspace(-eps^.5,1,101);                                       % boundaries of hazard intervals
npbins=length(edges)-1;                                              % number of hazard bins
density_lambda=zeros(npbins,1);                                      % initialize mass in each hazard bin with zero
for i=1:npbins                                                       % build density in hazard intervals
    density_lambda(i)=sum(vecPdisteroded((lambda>edges(i)...
                                         & lambda<=edges(i+1))));    % count of firms in hazard interval k 
end
npbins=length(density_lambda);                                       % number of p bins
npstep=(1/(npbins-1));
if abs(sum(density_lambda)-1)>eps^.5,                                % check sum
   sum(density_lambda)
   disp('Error: density L does not sum to one') 
end

% MEDIAN ADJUSTMENT GAIN D AND FIRM VALUE V
D_density=[D(:) vecPdist];                                           % matrix with D's and their density
D_density=sortrows(D_density,1);                                     % sort by D's ascending 
MedD=D_density(find(cumsum(D_density(:,2))>=.5,1),1);                % median gain D
Dopt_density=[Dopt(:) vecPdist];                                     % matrix with Dopt's and their density
Dopt_density=sortrows(Dopt_density,1);                               % sort by Dopt's ascending 
MedDopt=Dopt_density(find(cumsum(Dopt_density(:,2))>=.5,1),1);       % median gain Dopt
V_density=[V(:) vecPdist];                                           % matrix with V and their density
V_density=sortrows(V_density,1);                                     % sort by V ascending 
MedV=V_density(find(cumsum(V_density(:,2))>=.5,1),1);                % median firm value V

% MINIMUM, MAXIMUM, AVERAGE, AND STD DEVIATION OF ADJUSTMENT GAIN D
minD=min(min(D));                                                    % minimum loss out of all firms 
maxD=max(max(D));                                                    % maximum loss out of all firms 
MeanD=sum(sum(D.*Pdist));                                            % mean loss under PPS ("perceived loss")
MeanDopt=sum(sum(Dopt.*Pdist));                                      % mean loss if fully rational
StdD=sqrt(sum(sum((D-MeanD).^2.*Pdist)));                            % standard deviation of the loss of all firms 

% LOSS GRIDS AND ADJUSTMENT PROBABILITIES AT LOSS GRID POINTS
Dcutoff=0.001*MedV;                                                   % very few firms should forgo such huge gains
if maxD>minD && Dcutoff>minD                                         % prepare Lambda as a function of D graph 
   Dgrid=linspace(minD,maxD,201);
   %%% In logit case prob. lambda is a function of both D and adjcost !!!
   %%% Below we compute it for the "average" adjcost
   averadjcost=sum(sum(adjcost.*Pdisteroded));
   averadjcost=averadjcost*ones(size(Dgrid'));
   Lvalues = adjustment(adjtype, Dgrid'/wbar, ksi, alpha, lbar, averadjcost);
end

% HISTOGRAM OF LOSSES (based on Pdist)
edges=linspace(minD-eps^.5,Dcutoff+eps^.5,51);                       % boundaries of D intervals
nDbins=length(edges)-1;                                              % number of D bins
density_D=zeros(nDbins,1);                                           % initialize mass in each D bin with zero
for i=1:nDbins                                                       % build density in hazard intervals
    density_D(i)=sum(vecPdist((D>edges(i) & D<=edges(i+1))));        % count of firms in D interval k 
end
if abs(sum(density_D)-sum(vecPdist(D<=Dcutoff)))>eps^.5,             % check sum
   sum(density_D)
   sum(vecPdist(D<Dcutoff))
   error('Density D does not sum') 
end

% HISTOGRAM OF LOSSES (based on PdistEroded)
nDbins=length(density_D);                                            % number of D bins
%Dstep=(1/(nDbins-1));                                                % step for loss from inaction hist plot
Dstep=edges(2)-edges(1);
density_Derod=zeros(nDbins,1);                                       % initialize mass in each D bin with zero
for i=1:nDbins                                                       % build density in hazard intervals
  density_Derod(i)=sum(vecPdisteroded((D>edges(i)&D<=edges(i+1))));  % count of firms in D interval k 
end
if abs(sum(density_Derod)-sum(vecPdisteroded(D<=Dcutoff)))>eps^.5, 
   sum(density_Derod)
   sum(vecPdisteroded(D<=Dcutoff))
   error('Density Derod does not sum'),
end

% LOAD EMPIRICAL HISTOGRAM OF PRICE CHANGES AND PRICE CHANGE STATISTICS
midricalc;

% OTHER OBJECTS OF INTEREST 
% ergodicDistFlexPrice = Pmatrix(sgrid, Pgrid, pstep).*(ones(nump,nump)*(Pdist));
[pstarprob, pstarindex]=max(logitprobMAT);
pstar = Pgrid(pstarindex)';
Pdistans=ones(nump,1)*pstar-Pgrid*ones(1,nums);                      % matrix of distances from optimal price

optflexprice=log(exp(sgrid)*epsilon/(epsilon-1)*wbar);               % log of optimal flexible price
Pmat_ergodicDistFlexPrice = Pmatrix(optflexprice, Pgrid, pstep);
ergodicDistFlexPrice = Pmat_ergodicDistFlexPrice.*(ones(nump,nump)*(Pdist));

grossprofits = Cbar*(PMAT.^(1-epsilon)-wbar*sMAT.*PMAT.^(-epsilon));
revenue = Cbar*(PMAT.^(1-epsilon));

averprof = sum(sum(grossprofits.*Pdist)) - sum(sum(wbar*adjcost.*lambda.*Pdisteroded));
averoptprof = sum(sum(grossprofits.*ergodicDistFlexPrice));
avoptrev = sum(sum(revenue.*ergodicDistFlexPrice));

loss1 = (averoptprof - averprof)/ averoptprof;
loss2 = (averoptprof - averprof)/ avoptrev;
