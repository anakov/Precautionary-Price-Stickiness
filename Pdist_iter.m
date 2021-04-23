% Computes the steady state of Pdist and Pdisteroded
% version 17 april 2008

PdistDIFF=inf;                                              % reset difference of Pdist
Pdistiter=0;                                                % reset counter

while (PdistDIFF>tol && Pdistiter<1500)                     % iterate to convergence of Pdist
    Pdistiter=Pdistiter+1;                                  % increment counter

    Pdisteroded = RECURSEMAT*Pdist*TRANSMAT';               % distribution after productivity shock and deflation

    if  adjtype>5
        PdistNew = (1-lambda).*Pdisteroded + logitprobMAT.*(ones(nump,1)*sum(lambda.*Pdisteroded)); 
    else
        PdistNew = (1-lambda).*Pdisteroded + Pmatrix(pstar, Pgrid, pstep).*(ones(nump,nump)*(lambda.*Pdisteroded)); 
    end

    PdistDIFF=gridsize*max(max(abs(PdistNew-Pdist)));       % sup norm normalized by gridsize
    Pdist=PdistNew;                                         % updating Pdist   
end
