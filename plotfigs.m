% Plots steady-state objects
if adjtype<5, plotfigs_ssdp; break; end

set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure
colormap([0.73 0.83 0.96])
bar(Pchangegrid,pdfdata,1,'EdgeColor','none');  
hold on
stairs(Pchangegrid-pstep/2,denspchanges,'k');   % stairs is displaced half a step to the right
title('Density of price changes')
xlabel('Size of (log) price changes')
legend('AC Nielsen data','PPS model')
xlim([-0.55 0.55])
ylim([0 0.1])

figure
colormap([0.73 0.83 0.96])
bar(hazd)
xlabel('Months elapsed since last price adjustment')
title('Hazard rate: h(k) = f(k)/s(k-1)')
xlim([0.5 horizon+0.5])
ylim([0 0.5])

figure
colormap([0.73 0.83 0.96])
bar(MeanAbsPchangeTime)
xlabel('Months elapsed since last price adjustment')
title('Mean absolute price change as a function of time since adjustment')
xlim([0.5 horizon+0.5])

figure
mesh(sgrid,Pgrid-log(wbar)-markup,logitprobMAT)
title('Price setting strategy (logit probabilities)')
xlabel('Log (inverse) productivity')
ylabel('Log real price')
axis tight

figure
if nums>1
   mesh(sgrid,Pgrid-log(wbar)-markup,100*D/MedV)
   xlabel('Log (inverse) productivity')
   ylabel('Log real price')
 else
   plot(Pgrid-log(wbar)-markup,100*D/MedV)
   xlabel('Log real price')
end
title('Adjustment gain (% of median firm value)')
axis tight

figure
if nums>1
   mesh(sgrid,Pgrid-log(wbar)-markup,V)
   xlabel('Log (inverse) productivity')
   ylabel('Log real price')
 else
   plot(Pgrid-log(wbar)-markup,V)
   xlabel('Log real price')
end
title('Value function')
axis tight


figure
%map=colormap;
%colormap([1 1 1; map])
if nums>1
   contour(sgrid,Pgrid-log(wbar)-markup,Pdisteroded,10)
   xlabel('Log (inverse) productivity')
   ylabel('Log real price')
else
   plot(Pgrid-log(wbar)-markup,Pdisteroded)
   xlabel('Log real price')
end
title('Density of firms after productivity shocks and inflation')

figure
if nums>1
%   map=colormap;
%   colormap([1 1 1; map])
   contour(sgrid,Pgrid-log(wbar)-markup,Pdist,10)
   xlabel('Log (inverse) productivity')
   ylabel('Log real price')
else
   plot(Pgrid-log(wbar)-markup,Pdist)
   xlabel('Log real price')
end
title('Density of firms after adjustment')

figure
%map=colormap;
%colormap([1 1 1; map])
if nums>1
   contour(sgrid,Pgrid-log(wbar)-markup,(1-lambda).*Pdisteroded,10)
   xlabel('Log (inverse) productivity')
   ylabel('Log real price')
else
   plot(Pgrid-log(wbar)-markup,(1-lambda).*Pdisteroded)
   xlabel('Log real price')
end
title('Density of non-adjusting firms')

figure
%map=colormap;
%colormap([1 1 1; map])
if nums>1
   contour(sgrid,Pgrid-log(wbar)-markup,lambda.*Pdisteroded,10)
   xlabel('Log (inverse) productivity')
   ylabel('Log real price')
else
   plot(Pgrid-log(wbar)-markup,lambda.*Pdisteroded)
   xlabel('Log real price')
end
title('Density of adjusting firms')

   if nums>1
      figure
      contour(sgrid,Pgrid-log(wbar)-markup,lambda,[0.5 0.5],'k')
      xlabel('Log (inverse) productivity')
      ylabel('Log real price')
   else
      plot(Pgrid-log(wbar)-markup,lambda)
      xlabel('Log real price')
   end
   title('(S,s) adjustment bands')
   axis tight


figure
stairs((100*edges(1:end-1)/MedV),density_Derod,'b:')
hold on
stairs((100*edges(1:end-1)/MedV),density_D,'k')
title('Size distribution of potential and realized losses from inaction')
xlabel('Size of losses (or gains when negative) from inaction as % of median firm value')
ylabel('Density')
legend('Potential losses (before adjustment)','Realized losses (after adjustment)')
xlim([100*minD/MedV 0.2])
ylim([0 0.25])

figure
surf(lambda)
title('Probability of adjustment function')
xlabel('Log (inverse) productivity')
ylabel('Log real price')


% OTHER FIGURES
% figure
% if nums>1
%    mesh(sgrid,Pgrid,PAYOFFMAT)
%    xlabel('Log real marginal cost')
%    ylabel('Log real price')
%  else
%    plot(Pgrid,PAYOFFMAT)
%    xlabel('Log real price')
% end
% title('Profit function')
% axis tight

% if CalvoMenuMetric<1-2*eps^.5
% 
% % figure
% % for cols=1:length(pstar)
% %     plot(100*(Pgrid-pstar(cols)),lambda(:,cols))
% %     hold on
% %     xlabel('Percent distance from optimal price')
% %     ylabel('Probability of adjustment')
% %     title('Probability of price increase (left) or decrease (right)')
% % end
% % hold off
% 
% figure
% %for cols=1:length(pstar)
%     plot(100*(log(PMAT')-pstar'*ones(1,length(Pgrid))),lambda')
% %    hold on
% %    pause(0.2)
%     xlabel('Percent distance from optimal price')
%     ylabel('Probability of adjustment')
%     title('Probability of price increase (left) or decrease (right)')
% %end
% %hold off
%     
% end

% figure
% bar(0:npstep:1,density_lambda,1)
% title('Density of adjustment probabilities')
% xlabel('Adjustment probability lambda')
% ylabel('Density of firms (after shock)')
% xlim([-npstep/2 1+npstep/2])
% figure
% plot(Dgrid/MedV*100,Lvalues)
% title('Lambda as a function of D')
% xlabel('Loss from inaction (in % of firm''s median value)')
% ylabel('Probability of adjustment')
% ylim([0 1])