% InitOpt.m - initialization script for optimization package
% 
% sets up global data structure
% OPT_DATA:
%   OPT_DATA.pools          : vector of optimization pool sizes
%   OPT_DATA.poolnames      : cell array of names for optimization pools
%   OPT_DATA.procs          : array of base random processes
%   OPT_DATA.procs().basis  : basis function
%   OPT_DATA.procs().offset : basis offset
%   OPT_DATA.procs().Coeff  : basis frequency coefficients
%   OPT_DATA.procs().coeff  : basis time coefficients
%   OPT_DATA.ctprocs        : same as procs, but for c.t.
%   OPT_DATA.ndprocs        : same as procs, but for higher dimensions
%   OPT_DATA.regions        : array of Region data
%   OPT_DATA.casebug        : 1 to workaround windows mixed-case classnamebug
%   OPT_DATA.mexflag        : 1 to use MEX routines for speed

global OPT_DATA
OPT_DATA.pools=[];
OPT_DATA.poolnames = {};
OPT_DATA.procs=[];
OPT_DATA.ctprocs=[]; % new CTProcess field
OPT_DATA.ndprocs=[]; % new NDProcess field
OPT_DATA.regions=[];
OPT_DATA.casebug=strcmp(computer,'PCWIN'); % error only on PC/windoze?
OPT_DATA.mexflag = 1;   % use MEX routines for speed
