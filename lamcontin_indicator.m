function LAMBDA = lamcontin_indicator(scaleddiff)
% Approximates lambda in the menu cost model with a continuous function 
% This is an alternative to using SSDP with a high ksi 
%
%This function finds HALF-INTERVALS on which LAMBDA CHANGES from 0 to 1,
%   and uses a different formula to calculate lambda there.

[nr,nc] = size(scaleddiff);

%LINEAR INTERPOLATION OF D at 'midpoints' of grid:
diffinterp = interp1((1:nr)',scaleddiff,(0.5:nr+0.5)','linear','extrap');

%NOW CONSIDER THE 'HALF-INTERVALS' on left and right of each grid point.
%DEFINE LAMBDA ON EACH 'HALF-INTERVAL' AS FRACTION OF THAT HALF INTERVAL
%   ON WHICH LAMBDA=1.


%ALLOCATE LAMBDA TO LEFT HALF-INTERVALS:
Dlb = diffinterp(1:nr,:);
Dub = scaleddiff;
LAMlb = Dlb>0;   %lambda at left endpoint of half-interval
LAMub = Dub>0;   %lambda at right endpoint of half-interval

LAMleft = NaN*scaleddiff;
LAMleft(LAMlb==1 & LAMub==1) = 1;
LAMleft(LAMlb==0 & LAMub==0) = 0;
CHANGES = LAMlb~=LAMub;

LAMleft(CHANGES) = -LAMlb(CHANGES).*(Dlb(CHANGES)./(Dub(CHANGES)-Dlb(CHANGES))) + ...
                   LAMub(CHANGES).*(Dub(CHANGES)./(Dub(CHANGES)-Dlb(CHANGES)));

%ALLOCATE LAMBDA TO RIGHT HALF-INTERVALS:
Dlb = scaleddiff;
Dub = diffinterp(2:nr+1,:);
LAMlb = Dlb>0;   %lambda at left endpoint of half-interval
LAMub = Dub>0;   %lambda at right endpoint of half-interval

LAMright = NaN*scaleddiff;
LAMright(LAMlb==1 & LAMub==1) = 1;
LAMright(LAMlb==0 & LAMub==0) = 0;
CHANGES = LAMlb~=LAMub;

LAMright(CHANGES) = -LAMlb(CHANGES).*(Dlb(CHANGES)./(Dub(CHANGES)-Dlb(CHANGES))) + ...
                   LAMub(CHANGES).*(Dub(CHANGES)./(Dub(CHANGES)-Dlb(CHANGES)));
               
%NOW ALLOCATE LAMBDA TO ORIGINAL GRID POINTS:
LAMBDA = 0.5*(LAMleft+LAMright);
%lambda at grid point is average of lambdas on left and right half-intervals.