
figure(8)

load fmc
linescolor= 'bo-';
linewidth=0.5;
plotirf_slides

load calvo
linescolor= 'gs-';
linewidth=0.5;
plotirf_slides
clear

load pps
linescolor= 'r.-';
linewidth=0.5;
plotirf_slides

load ent
linescolor= 'm';
linewidth=2;
plotirf_slides


legend('FMC','Calvo','PPS','ENT')
legend boxoff
