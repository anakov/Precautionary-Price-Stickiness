% Plots steady-state objects

load ent

set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure(1)

subplot(2,2,1)
mesh(sgrid,Pgrid-log(wbar)-markup,logitprobMAT)
title('Logit probabilities: ENT')
xlabel('Log cost')
ylabel('Log real price')
axis tight


subplot(2,2,2)
   if nums>1
      contour(sgrid,Pgrid-log(wbar)-markup,lambda,[0.5 0.5],'k')
      xlabel('Log cost')
      ylabel('Log real price')
   else
      plot(Pgrid-log(wbar)-markup,lambda)
      xlabel('Log real price')
   end
   title('(S,s) adjustment bands: ENT')
   axis tight

load pps
   
subplot(2,2,3)
mesh(sgrid,Pgrid-log(wbar)-markup,logitprobMAT)
title('Logit probabilities: PPS')
xlabel('Log cost')
ylabel('Log real price')
axis tight

subplot(2,2,4)
   if nums>1
      contour(sgrid,Pgrid-log(wbar)-markup,lambda,[0.5 0.5],'k')
      xlabel('Log cost')
      ylabel('Log real price')
   else
      plot(Pgrid-log(wbar)-markup,lambda)
      xlabel('Log real price')
   end
   title('(S,s) adjustment bands: PPS')
   axis tight
