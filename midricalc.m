% Loads Midrigan's price change statistics and histogram

 load acnielsen ; 
% load dominicks ; if version<3, disp('Dominick''s data'), end;

MeanPriceChange     = mean(data);
MeanAbsPriceChange  = mean(abs(data));
MedAbsPriceChange   = median(abs(data));
MeanPriceIncrease   = mean(data(data>0));
MedianPriceIncrease = median(data(data>0));
MeanPriceDecrease   = mean(data(data<0));
MedianPriceDecrease = median(data(data<0));
StdPriceChanges     = std(data);
KurtPriceChanges    = kurtosis(data);
FracPriceIncreases  = sum(data>0)/length(data);
FracPriceDecreases  = sum(data<0)/length(data);
PctLessthan5        = sum(abs(data)<=0.05+eps^.5)/length(data);
PctLessthan25        = sum(abs(data)<=0.025+eps^.5)/length(data);

pdfdata = ksdensity(data,Pchangegrid);
pdfdata = pdfdata/sum(pdfdata);



