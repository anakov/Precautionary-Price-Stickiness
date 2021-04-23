
if  adjtype>5
    x=sum(logitprobMAT.*(ones(nump,1)*sum(lambda.*Pdisteroded)),2);
else
    x=sum(Pmatrix(pstar, Pgrid, pstep).*(ones(nump,nump)*(lambda.*Pdisteroded)),2);
end
y=sum((1-lambda).*Pdisteroded ,2);

