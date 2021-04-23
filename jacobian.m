% Computes Jacobian matrix by forward differences
% Inputs:
% func: string, name of function
% f0: function value at point x
% x: point at which to take Jacobian
% step: scalar, relative stepwidth;

function jac = jacobian(func,f0,x0,step)
  set(0,'DefaultFigureWindowStyle','normal')       % undocks all figures
  disp(sprintf('Maximum residual: %d', max(abs(f0))))
  n = size(x0,1);  
  m = size(f0,1); 
  disp(sprintf('\n'))  
  disp(sprintf('SIZE OF JACOBIAN: %0.1f million elements',m*n/1e6))  
  disp(sprintf('No. equations: %d,  No. arguments: %d',[m, n]))  
  jac = sparse([],[],[],m,n,round(0.05*m*n)); 
  h = waitbar(0,'Computing Jacobian matrix. Please, wait...');
  for i=1:n
    if rem(i,100)==0, waitbar(i/n,h), end
    step2 = step*max(1,abs(x0(i)));   % step2=step when ss value is < 1; otherwise scale up by ss value
    x = x0;
    x(i) = x0(i) + step2;
    jac(1:m,i) = (feval(func,x) - f0)/step2;
  end
  close(h) 