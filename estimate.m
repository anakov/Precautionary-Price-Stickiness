% Estimates the model's parameters from data on price changes
clear; clc; tic
fprintf('\n Estimation in progress ... (this may take a while) \n')
etol = eps^.5;

guess  = [0.003; 0.15];   
x_fval = [guess; NaN];   

save estiparam_logit   x_fval

ub    = [0.1 ;   0.25];  % upper bound  
lb    = [0.0005; 0.02];  % lower bound  


options=optimset('Display','iter','OutputFcn', @optimprint, 'Algorithm','active-set',...'interior-point',...
   'tolFun',10*etol,'tolX',10*etol,'DiffMaxChange',1000*etol,'DiffMinChange',etol,'UseParallel','always');

[Paramvector,fval,exitflag,output,lambda,grad] = fmincon('distance',guess,[],[],[],[],lb,ub,[],options); toc

load estiparam_logit
format long


noise =  x_fval(1,end)
lbar =  x_fval(2,end)
