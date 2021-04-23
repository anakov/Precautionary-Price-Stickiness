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

figure(10) 

subplot(1,3,1)
hold on
plot(intensive_path,linescolor,'MarkerSize', MarkerSize,'LineWidth',linewidth)
title('Intensive margin')
box off
xlabel('Months')
ylim([-0.05 3])

subplot(1,3,2)
hold on
plot(extensive_path,linescolor,'MarkerSize', MarkerSize,'LineWidth',linewidth)
title('Extensive margin')
box off
xlabel('Months')
ylim([-0.05 3])

subplot(1,3,3)
hold on
plot(selection_path,linescolor,'MarkerSize', MarkerSize,'LineWidth',linewidth)
title('Selection effect')
box off
xlabel('Months')
ylim([-0.05 3])
