% Plots impulse-response functions

%alternating color for irf plots
% linescolorGrid = {'r.-','bo-','gs-'};  % linecol = 1, 2, 3 for 'r.-','gs-','bo-'
% if ~exist('linecol','var') || linecol==3; 
%      linecol=1;
% else
%      linecol=linecol+1;
% end;

set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

MarkerSize = 5;
% linescolor=linescolorGrid{linecol};

subplot(1,3,1)
hold on
plot(scalefactor*(d_A_path+d_R_path),linescolor,'MarkerSize', MarkerSize,'LineWidth',linewidth)  % plots the non-zero impulse
title('Money growth process')
box off
%legend('Calvo','SDSP')
xlabel('Months')
ylim([-0.05 3.5])

subplot(1,3,2)
hold on
plot(scalefactor*(PI_path-mu),linescolor,'MarkerSize',MarkerSize,'LineWidth',linewidth)
title('Inflation')
box off
xlabel('Months')
ylim([-0.05 3.5])

subplot(1,3,3)
hold on
plot(scalefactor*(C_path/Cbar-1),linescolor,'MarkerSize', MarkerSize,'LineWidth',linewidth)
title('Consumption')
box off
xlabel('Months')
ylim([-0.05 3.5])
