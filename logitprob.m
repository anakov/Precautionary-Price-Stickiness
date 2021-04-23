function logitprobMAT = logitprob(VMAT, noise, wbar) 
% Computes logit probabilities based on payoff and noise parameter

onesvec = ones(rows(VMAT),1);
nomiMAT  = exp( (VMAT - onesvec*max(VMAT))./ wbar /noise );
denomMAT = onesvec*sum(nomiMAT);

logitprobMAT = nomiMAT./denomMAT;