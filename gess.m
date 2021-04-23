% Main program for "Precautionary Price Stickiness"
% version November 2009, rootfinding on wbar
% Solve general equilibrium steady-state searching for the wage that satisfies the aggregate price identity

%clear all;
tic; 
global fzeroiter

if exist('GE_ss.mat','file'), delete GE_ss.mat, end;

fzeroiter = 0;                                           % reset iteration counter

param;                                                   % load macro parameters and the guess for wages "wflex"
adjparams;

options = optimset('Display','off','TolFun',tol);        % set convergence tolerance level and silent mode 

[wbar,fval,exitflag] = fzero('Pidentity',[0.9*wflex 1.1*wflex],options); % find equilibrium wage given "wflex" as inital guess

if abs(fval)>tol, fval; warning('Convergence failure'); end     % check convergence

clear;
load GE_ss;                                              % load steady-state objects into workspace
clear data;

if adjtype<5, calcstats_ssdp; else calcstats; end        % calculate steady-state statistics

if showconverge
   printstats                                             % print steady-state statistics
%  plotfigs                                               % plot steady-state graphs
   fprintf('\n')  
   fprintf('Elapsed time: %d seconds', round(toc))  
end
