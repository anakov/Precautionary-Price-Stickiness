figure(9)

load pps
linescolor= 'r.-';
linewidth=0.5;
plotirf_slides
clear

load pps_halfnoise
linescolor= 'bo-';
linewidth=0.5;
plotirf_slides
clear

load pps_doublenoise
linescolor= 'gs-';
linewidth=0.5;
plotirf_slides

legend('baseline','noise x 1/2','noise x 2')
legend boxoff
