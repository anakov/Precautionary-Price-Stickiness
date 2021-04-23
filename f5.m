% Plots steady-state objects
set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure(5)

kksize   = [92.5 101 101.5 101 104 101.5 103 107 106 110 102 105];

load pps; 
horiz = length(kksize);
scale=mean(MeanAbsPchangeTime(1:horiz));
MeanAbsPchangeTime=MeanAbsPchangeTime/scale*100;
subplot(1,3,3)
plot(1:horiz,kksize,'b--');  
hold on
plot(MeanAbsPchangeTime(1:horiz),'k')
load ent;
scale=mean(MeanAbsPchangeTime(1:horiz));
MeanAbsPchangeTime=MeanAbsPchangeTime/scale*100;
plot(MeanAbsPchangeTime(1:horiz),'b','LineWidth',2)
legend('Klenow-Kryvtsov','PPS','ENT') 
legend boxoff
xlabel('Months since last change')
title('PPS')
xlim([0.5 horiz+0.5])
%ylim([48 140])
ylim([0 140])

load fmc; 
scale=mean(MeanAbsPchangeTime(1:horiz));
MeanAbsPchangeTime=MeanAbsPchangeTime/scale*100;
subplot(1,3,1)
plot(1:horiz,kksize,'b--');  
hold on
plot(MeanAbsPchangeTime(1:horiz),'k')
xlabel('Months since last change')
ylabel('Size of price changes')
title('FMC')
xlim([0.5 horiz+0.5])
%ylim([48 140])
ylim([0 140])

load calvo; 
scale=mean(MeanAbsPchangeTime(1:horiz));
MeanAbsPchangeTime=MeanAbsPchangeTime/scale*100;
subplot(1,3,2)
plot(1:horiz,kksize,'b--');  
hold on
plot(MeanAbsPchangeTime(1:horiz),'k')
xlabel('Months since last change')
title('Calvo')
xlim([0.5 horiz+0.5])
%ylim([48 140])
ylim([0 140])