% Calculates decomposition of inflation into intensive, extensive, selection effects

%The steady state objects needed for this calculation are:
%   Pdisteroded: beginning-of-period distribution
%   lambda: the whole function lambda(p,a), nump x nums
%   Pdistans: matrix of desired LOG price adjustments (pstar-Pgrid), nump x nums 

format compact

%period in which money shock occurs - must be same as in "irf.m"
if exist('shocktime','var')
   if Rshocks(shocktime)>0
      d_shock = d_R_path(shocktime);
   elseif TFPshocks(shocktime)>0
      d_shock = d_A_path(shocktime);
   end
else
   d_shock = 1/scalefactor;
end
if d_shock == 0, d_shock = 1/scalefactor; end     % if there is no shock, take differences

% INFLATION IMPACT RESPONSE
dPI_dmu = (PI_path(time)-mu) / d_shock; 

% NAKOV-COSTAIN DECOMPOSITION
% INFLATION = sum(sum(Pdistans.*(lambda - sum(sum(lambda .*Pdisteroded))).*Pdisteroded)) + ...
%    sum(sum(Pdistans.*Pdisteroded ))  *  sum(sum(lambda.*Pdisteroded )) ;
    
selection = sum(sum(Pdistans.*(lambda - sum(sum(lambda .*Pdisteroded))).*Pdisteroded));
intensive = sum(sum(Pdistans.*Pdisteroded )) ; 
extensive = sum(sum(lambda.*Pdisteroded ))   ;

d_Pchanges = (Pchanges_path(:,:,time) - Pdistans) / d_shock;
d_PhiTilde = (reshape(PhiTilde_path(:,time),nump,nums) - Pdisteroded) / d_shock;

d_intens = sum(sum(d_Pchanges.*Pdisteroded + Pdistans.*d_PhiTilde));  % element by element so derivative okay
d_extens = (frac_adjusters_path(time) - freqpchanges) / d_shock;

intensive_margin = d_intens*extensive; 
extensive_margin = d_extens*intensive; 
selection_effect = dPI_dmu - extensive_margin - intensive_margin ;

if 0
  disp(sprintf('\n'))  
  disp(sprintf('INFLATION IMPACT : %0.3g ',dPI_dmu))
  disp(sprintf('AN decomp: %0.3g   intensive: %0.3g  extensive: %0.3g  selection  : %0.3g ',...
                       [dPI_dmu, intensive_margin, extensive_margin, selection_effect]))
end


% KLENOW-KRYVTSOV DECOMPOSITION
% inflation = freqpchanges*EPchange
% dfreqpchanges_dmu = (frac_adjusters_path(time) - freqpchanges) / d_shock;
% dAvPchange_dmu    = (AvPchange_path(time) - EPchange) / d_shock;
% 
% KKintensive = dAvPchange_dmu * freqpchanges;
% KKextensive = dfreqpchanges_dmu * EPchange ;
% KK_decomp = KKintensive + KKextensive ;

