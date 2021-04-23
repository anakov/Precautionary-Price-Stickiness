% Solves dynamic stochastic general equilibrium using Klein's method

if phiPI > 0, dynsolveklein; else  dynsolvekleinM; end    % run Taylor rule or money growth shock
irf; 