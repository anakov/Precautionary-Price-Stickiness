% Plots steady-state objects
%set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

figure(3)

load pps; 
subplot(1,3,3)
bar(Pchangegrid,pdfdata,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96]);
hold on
stairs(Pchangegrid-pstep/2,denspchanges,'k');  
load ent
stairs(Pchangegrid-pstep/2,denspchanges,'b','LineWidth',2);  
xlabel('Size of price changes')
title('PPS')
legend('AC Nielsen data','PPS','ENT') 
legend boxoff
xlim([-0.55 0.55])
ylim([0 0.3])


subplot(1,3,1)
load fmc; 
bar(Pchangegrid,pdfdata,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96]);
hold on
stairs(Pchangegrid-pstep/2,prob,'k');   
%plot(Pchangegrid,prob,'k');   
xlabel('Size of price changes')
ylabel('Density')
title('FMC')
xlim([-0.55 0.55])
ylim([0 0.3])


subplot(1,3,2)
load calvo; 
bar(Pchangegrid,pdfdata,1,'EdgeColor','none','FaceColor',[0.73 0.83 0.96]);
hold on
stairs(Pchangegrid-pstep/2,prob,'k');   
%plot(Pchangegrid,prob,'k');   
xlabel('Size of price changes')
title('Calvo')
xlim([-0.55 0.55])
ylim([0 0.3])

