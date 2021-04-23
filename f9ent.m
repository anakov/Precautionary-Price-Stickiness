figure(11)

load ent
linescolor= 'r.-';
linewidth=0.5;
plotirf_slides
clear

load ent_halfnoise
linescolor= 'bo-';
linewidth=0.5;
plotirf_slides
clear

load ent_doublenoise
linescolor= 'gs-';
linewidth=0.5;
plotirf_slides

legend('baseline','noise x 1/2','noise x 2')
legend boxoff
