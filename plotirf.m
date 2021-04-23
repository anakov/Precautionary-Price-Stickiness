% Plots impulse-response functions

% alternating color for irf plots
linescolorGrid = {'r.-','gs-','bo-'};       % linecol = 1, 2, 3 for 'r.-','gs-','bo-'
if ~exist('linecol','var') || linecol==3; 
     linecol=1;
else
     linecol=linecol+1;
end;

set(0,'DefaultFigureWindowStyle','docked')  % docks all figures

MarkerSize = 5;
linescolor=linescolorGrid{linecol};

figure(1)
subplot(3,3,1)
hold on
plot(scalefactor*(d_A_path+d_R_path),linescolor,'MarkerSize', MarkerSize)  % plots the non-zero impulse
title('Shock process')
box off
%legend('Calvo','SDSP')

subplot(3,3,2)
hold on
plot(scalefactor*(PI_path-mu),linescolor,'MarkerSize',MarkerSize)
title('Inflation')
box off

subplot(3,3,3)
hold on
plot(scalefactor*(R_path-Rss),linescolor,'MarkerSize', MarkerSize) % this is the monthly interest rate
title('Nominal interest rate')
box off

% subplot(4,3,4)
% hold on
% plot(intensive_margin_path,linescolor,'MarkerSize', MarkerSize)
% title('Intensive margin')
% y = ylim;
% 
% subplot(4,3,5)
% plot(extensive_margin_path,linescolor,'MarkerSize', MarkerSize)
% title('Extensive margin')
% hold on
% ylim(y)
% xlim([0 TT])
% 
% subplot(4,3,6)
% plot(selection_effect_path,linescolor,'MarkerSize', MarkerSize)
% title('Selection effect')
% hold on
% ylim(y)
% xlim([0 TT])

subplot(3,3,4)
hold on
plot(scalefactor*(C_path/Cbar-1),linescolor,'MarkerSize', MarkerSize)
title('Consumption')
box off

subplot(3,3,5)
hold on
plot(scalefactor*(labor_path/Nbar-1),linescolor,'MarkerSize', MarkerSize)
title('Labor')
box off

subplot(3,3,6)
hold on
plot(scalefactor*(delta_wedge/WeightPriceDispers-1),linescolor,'MarkerSize', MarkerSize)
title('Price dispersion')
box off

subplot(3,3,7)
hold on
plot(scalefactor*ex_ante_real_interest_rate,linescolor,'MarkerSize', MarkerSize)
title('Real interest rate')
xlabel('Months')
box off

subplot(3,3,8)
hold on
plot(scalefactor*(w_path/wbar-1),linescolor,'MarkerSize', MarkerSize)
title('Real wage')
xlabel('Months')
box off

subplot(3,3,9)
hold on
plot(scalefactor*(m_path/mbar-1),linescolor,'MarkerSize', MarkerSize)
title('Real money holdings')
xlabel('Months')
box off
