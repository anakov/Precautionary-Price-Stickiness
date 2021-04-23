function adjcost = cost(adjtype, alpha, noise, syntropy)
% Returns adjustment cost to be subtracted from profit flow

switch adjtype
    case {1,2,4,6}                              % Calvo, SSDP, PPS, Woodford 
      adjcost = 0;
    case 3                                      % FMC
      adjcost = alpha;                  
    case 7                                      % ENT (simple Logit)
      adjcost = noise*syntropy;              
    case 8                                      % Nested Logit 
      adjcost = noise*syntropy;              
    
end  
     

