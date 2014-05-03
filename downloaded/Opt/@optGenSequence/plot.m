function plot(seq,varargin) 
% OPTGENSEQUENCE/PLOT Graphical representation of optGenSequence

plot(optArray(seq),varargin{:}) % the {:} allows varargin to be
                                % passed through untouched
