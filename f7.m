% fig.6: frequency and size of price changes at different inflation rates
load gagnon.mat

set(0,'DefaultFigureWindowStyle','docked')  % docks all figures
density = dpc.Fig_pd;

lbound = -.6;
ubound =  .6;
edges  = linspace(lbound,ubound,61);                                
nDbins = length(edges)-1;                                          
step   = (ubound-lbound)/(length(density)-1);

binwidth = edges(2)-edges(1);
meanbinpoint = edges'+binwidth/2;
meanbinpoint = meanbinpoint(1:end-1);

averPriceChangeG = sum(density.*(meanbinpoint*ones(1,3)));
stdPchanges = (sum((meanbinpoint*ones(1,3)-ones(nDbins,1)*averPriceChangeG).^2.*density)).^.5;

inflationcheck = averPriceChangeG.*dpc.avefreq';
%gagnon_inflations = dpc.aveinf';

gagnon_inflations = 100*((1+dpc.aveinf').^12-1);

gagnon_increases=sum(dpc.Fig_pd(30:end,:));

figure(7)
subplot(1,3,1)
plot(gagnon_inflations, dpc.avefreq','b--')
hold on
plot([0 gagnon_inflations], [0.10 0.113 0.233 0.352],'gs-')  % Menu cost
plot([0 gagnon_inflations], [0.10 0.124 0.245 0.331],'k')  % PPS
plot([0 gagnon_inflations], [0.10 0.118 0.231 0.355],'b','LineWidth',2)  % ENT
xlim([-1 max(gagnon_inflations)+1])
title('Av. freq. of price changes')
legend('Gagnon (2007)','FMC','PPS','ENT')
legend boxoff
xlabel('Annual inflation (%)')

subplot(1,3,2)
plot(gagnon_inflations ,stdPchanges','b--')
hold on
plot([0 gagnon_inflations], [5.64 5.40 1.89 2.34]/100,'gs-')  % Menu cost
plot([0 gagnon_inflations], [14.5 14.6 17.7 17.2]/100,'k')  % PPS
plot([0 gagnon_inflations], [7.32 7.28 5.44 5.57]/100,'b','LineWidth',2)  % ENT
title('Std. dev. of price changes')
xlim([-1 max(gagnon_inflations)+1])
xlabel('Annual inflation (%)')


subplot(1,3,3)
plot(gagnon_inflations,gagnon_increases,'b--')
hold on
plot([0 gagnon_inflations], [50.7 75.2 99.7 100]/100,'gs-')  % Menu cost
plot([0 gagnon_inflations], [50.0 60.4 73.3 80.5]/100,'k')  % PPS
plot([0 gagnon_inflations], [50.0 71.0 96.2 98.5]/100,'b','LineWidth',2)  % ENT
xlim([-1 max(gagnon_inflations)+1])
title('Frac. of price increases')
xlabel('Annual inflation (%)')
