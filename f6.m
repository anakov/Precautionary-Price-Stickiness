% Plots steady-state objects
set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure(6)

xticks = (-47.5:5:47.5)/100;
ucampbel   = [79 71 72 80 73 64 53 48 42 35 37 45 48 50 48 51 55 58 63 72]/100;
sizedata = length(ucampbel);

load pps; extreme
subplot(1,3,3)
plot(xticks,ucampbel,'b--')
hold on
plot(Pgrid,x./(x+y),'k')
load ent; extreme
plot(Pgrid,x./(x+y),'b','LineWidth',2)
legend('Campbell-Eden','PPS','ENT') 
legend boxoff
xlabel('Deviation from average price')
title('PPS')
xlim([-0.25 0.25])
ylim([0 1])

load fmc; extreme
subplot(1,3,1)
plot(xticks,ucampbel,'b--')
hold on
plot(Pgrid,x./(x+y),'k')
ylabel('Fraction of young prices')
xlabel('Deviation from average price')
title('FMC')
xlim([-0.25 0.25])
ylim([0 1])

load calvo; extreme
subplot(1,3,2)
plot(xticks,ucampbel,'b--')
hold on
plot(Pgrid,x./(x+y),'k')
%plot(xticks,lbar*ones(length(ucampbel),1),'k')
xlabel('Deviation from average price')
title('Calvo')
xlim([-0.25 0.25])
ylim([0 1])
