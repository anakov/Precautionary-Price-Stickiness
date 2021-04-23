% Plots steady-state objects

load ent

set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure(2)
subplot(2,1,1)
bar((100*edges(1:end-1)/avoptrev ),density_Derod,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96])
hold on
stairs((100*edges(1:end-1)/avoptrev )-100*Dstep/2/avoptrev,density_D,'k')
title('Size distribution of losses: ENT')
xlabel('Loss as % of flex price revenue')
ylabel('Density')
legend('Potential','Realized')
legend boxoff
xlim([100*minD/avoptrev-100*Dstep/2/avoptrev-0.05   4.5])
ylim([0 0.25])

load pps
calcstats
subplot(2,1,2)
bar((100*edges(1:end-1)/avoptrev ),density_Derod,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96])
hold on
stairs((100*edges(1:end-1)/avoptrev )-100*Dstep/2/avoptrev ,density_D,'k')
title('Size distribution of losses: PPS')
xlabel('Loss as % of flex price revenue')
ylabel('Density')
legend('Potential','Realized')
legend boxoff
xlim([100*minD/avoptrev-100*Dstep/2/avoptrev-0.05   4.5])
ylim([0 0.1])

