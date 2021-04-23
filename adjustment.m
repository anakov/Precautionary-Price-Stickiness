function lambda = adjustment(adjtype, L, ksi, alpha, lbar, adjcost)
% Returns matrix of adjustment probabilities as a function of the state

switch adjtype
    case 1                    % SSDP 
        aL = (alpha./L).^ksi;                          
        lambda = lbar./((1-lbar)*aL+lbar);             
    case 2                    % CALVO
        lambda = lbar*ones(size(L)) ;
    case {3,6,7}              % INDICATOR FUNCTION L>=adjcost
        lambda = lamcontin_indicator(L-adjcost);
    case 4                    % WOODFORD
        argexp = (alpha-L)/ksi;
        lambda = lbar./((1-lbar).*exp(argexp) + lbar); 
    case 8                    % NESTED LOGIT with interpolation
        argexp = (adjcost-L)/ksi;
        lambdaW = lbar./((1-lbar).*exp(argexp) + lbar); 
            
        nr = size(argexp,1);
        argexpinterp = interp1((1:nr)',argexp,(0.5:0.1:nr+0.5)','linear','extrap');
                
        lambdaSmoothBIG = lbar./((1-lbar).*exp(argexpinterp) + lbar); 
        for i = 0:nr-1
          lambdaSmooth(i+1,:) = mean(lambdaSmoothBIG(i*10+1:i*10+11,:));
        end
        weightS = 1./(1+argexp.^2); 
        lambda = (1-weightS).*lambdaW + weightS.*lambdaSmooth;
end  

