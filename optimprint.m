function stop = optimprint(x,optimValues,state)
% Prints and stores to disk current parameter estimate

stop = false;
switch state
case 'iter'
      fprintf('\n Parameter Vector = (%0.5g, %0.5g)', x)  
      fprintf('\n')  
      fprintf('\n')  
      load estiparam_logit
      
      x_fval = [x_fval [x; optimValues.fval]];
      
      save estiparam_logit  x_fval 
end
end

