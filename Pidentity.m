function zero = Pidentity(wbar)
% Function called by fzero to find the general equilibrium
% searches over the wage rate that satisfies the aggregate price identity
% input : guess for wages
% output: residual of the price identity equation (fzero tries to minimize this)

gamma = NaN;                                                % initializes gamma as a parameter (vs the gamma function)
Pdist = NaN;                                                % initializes Pdist as a variable (vs the pdist function)

findPEVfun;                                                 % find steady-state value function for a given wage "wbar"
Pdist_iter;                                                 % get stationary distribution of firms on (price,cost) 
zero=1-sum(sum(PMAT.^(1-epsilon).*Pdist))^(1/(1-epsilon));  % compute residual of the price level identity

if abs(zero)<tol                                            % if converged, save the workspace
   save GE_ss
end