% Plots steady-state objects
set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure(4)

nakahazd = [0.205 0.155 0.125 0.12 0.105 0.105 0.103 0.098 0.096 0.094 0.103 0.115 0.103 0.08 0.103 0.085 0.075 0.07];
kkhazd   = [0.51 0.235 0.195 0.15 0.13 0.13 0.108 0.103 0.10 0.09 0.11 0.22 0.113 0.08 0.07 0.06 0.07 0.055 ];

load pps; 
horizon = length(nakahazd);
subplot(1,3,3)
plot(1:horizon,nakahazd,'b.-');  
hold on
plot(1:horizon,kkhazd,'r--');  
%bar(hazd,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96]);
plot(hazd(1:horizon),'k')
load ent
plot(hazd(1:horizon),'b','LineWidth',2)
legend('Nakamura-Steinsson','Klenow-Kryvtsov','PPS','ENT')  
legend boxoff
%stairs((1:horizon)-0.5,hazd(1:horizon),'k');  
xlabel('Months since last change')
title('PPS')
xlim([0 18-0.5])
ylim([0 0.5])


load fmc; 
horizon = length(nakahazd);
subplot(1,3,1)
%bar(hazd,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96]);
%stairs((1:horizon)-0.5,nakahazd,'k');  
plot(1:horizon,nakahazd,'b.-');  
hold on
plot(1:horizon,kkhazd,'r--');  
plot(hazd(1:horizon),'k')
%stairs((1:horizon)-0.5,hazd(1:horizon),'k');  
xlabel('Months since last change')
ylabel('Probability of price change')
title('FMC')
%legend('data') 
%legend boxoff
xlim([0 horizon-0.5])
ylim([0 0.5])

load calvo;
horizon = length(nakahazd);
subplot(1,3,2)
%bar(hazd,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96]);
%stairs((1:horizon)-0.5,nakahazd,'k');  
plot(1:horizon,nakahazd,'b.-');  
hold on
plot(1:horizon,kkhazd,'r--');  
plot(hazd(1:horizon),'k')
%stairs((1:horizon)-0.5,hazd(1:horizon),'k');  
xlabel('Months since last change')
title('Calvo')
%legend('data') 
%legend boxoff
xlim([0 horizon-0.5])
ylim([0 0.5])
