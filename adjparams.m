% Sets idiosyncratic shock and adjustment parameters
rho   = 0.95;        % Blundell and Bond (2000): 0.5 annual = 0.95 monthly 
stdMC = 0.06;        % Eichenbaun, Jaimovich, Rebelo (2009): 
                     % stdMC = 0.06 (NBER WP13829 Table 2)
switch adjtype            
    
   case 1  % SSDP (JME calibration)
        lbar  = 0.110074147699003;
        alpha = 0.037210419907043;
        ksi   = 0.234597262202440;
        rho   = 0.900196054582284;
        stdMC = 0.155496755673145;
        
   case 2 % CALVO 
        if version<3
        lbar  = 0.10;                    
        end
        ksi = []; alpha = 0;
      
   case 3 % MENU COST  
        if version<3
        alpha =  0.00808650443112;         
        end
        ksi = []; lbar = [];

   case 4 % WOODFORD
        if version<3   % NOT ESTIMATED YET
        ksi =  1;   
        lbar = 0.08;   
        alpha = 0.02; 
        end
        
   case 6 % PPS        
        if version<3
        %noise = 0.038182374403334;  % grid with gridSpread = 3     % noise = 0.042760772863787; % grid with gridSpread = 0
        noise = 0.042760772863787; % grid with gridSpread = 0
        end
        alpha = 0; ksi = []; lbar = [];   
   
   case 7 % ENT 
        if version<3
        %noise = 0.004094663384698;  % grid with gridSpread = 3    % noise = 0.004953755120325; % grid with gridSpread = 0
         noise = 0.004953755120325;
        end
        alpha = []; ksi = []; lbar = [];   
        
   case 8 % NESTED LOGIT  
        if version<3      % NOT ESTIMATED YET
        noise = 0.003914026852031;
        lbar = 0.174206102937214;
        end
        ksi = noise;
        alpha = []; 
end