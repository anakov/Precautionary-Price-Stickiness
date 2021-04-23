% Builds cost and price grids in logs                
 
if finegrid==0                                      % use this for dynamics
     nums = 25;                                     % number of cost grid points 
     numstddevs = 4;                                % number of standard deviations around midpoint
     %numstddevs = 3;                                % number of standard deviations around midpoint
elseif finegrid==1                                  % use this for steady-state computation only
   nums = 201;                                      % number of cost grid points 
   NumPpoints = 201;                                % approximate number of price points; nump will be the actual
   numstddevs= 5;                                   % number of standard deviations around midpoint
elseif finegrid==-1                                 % use this for rep agent case
   nums = 1;                                        % number of cost grid points 
   NumPpoints = 3;                                  % number of price points on coarse grid
   numstddevs = 1;                                  % number of standard deviations around midpoint
end

%gridSpread = 3 + 5*(mu>infparam('GanLow'));         % extra grid points in price dimension
gridSpread =  5*(mu>infparam('GanLow'));         % extra grid points in price dimension

SMAX=numstddevs*stdMC;                              % maximum cost
SMIN=-numstddevs*stdMC;                             % minimum cost
sstep=(SMAX-SMIN)/(nums-1);                         % distance between state grid points
sgrid=SMIN:sstep:SMAX;                              % marginal cost grid (log)     

pstep = sstep;                                      % distance between price grid points

markup = log(epsilon/(epsilon-1));                  % optimal flexible price markup

if idioshocks == -1,                                % representative agent case
   nums=1;                                          % single productivity state
   SMAX=0;                                          % single grid point at zero log productivity
   SMIN=0;                                          % productivity=1 in levels
   sgrid=0;
   PMAX = markup + log(wflex) + gridSpread*0.02;    % need positive gridSpread for this to work       
   PMIN = markup + log(wflex) - gridSpread*0.02;          
else
   PMAX = markup + log(wflex) + SMAX + gridSpread*pstep; % maximum price (based on flex price policy)
   PMIN = markup + log(wflex) + SMIN - gridSpread*pstep; % minimum price
end

offset = log(mu)/pstep;                             % noninteger number of price steps caused by inflation
Pgrid=(PMIN:pstep:PMAX)';                           % price grid (log)
nump=length(Pgrid);                                 % number of price grid points
gridsize=nump*nums;                                 % total number of grid points 
