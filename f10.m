
clear
load fmc
linescolor = 'bo-';
linewidth=0.5;
plot_infdec

clear;
load calvo
linescolor = 'gs-';
linewidth=0.5;
extensive_path=0*extensive_path;
selection_path=0*selection_path;
plot_infdec

clear
load pps
linescolor = 'r.-';
linewidth=0.5;
plot_infdec

clear
load ent
linescolor = 'm';
linewidth=2;
plot_infdec

figure(10) 

subplot(1,3,1)
legend('FMC','Calvo','PPS','ENT')
legend boxoff
