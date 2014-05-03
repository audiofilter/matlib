function plot(seq,varargin) 
% OPTSEQUENCE/PLOT Graphical representation of optSequence
%   plot(seq) plots optSequence seq.
%   plot(seq, ...) plots seq with comma-separated list 
%       of plotting options.
%       options can be one or more of:
%  'color, 'nocolor':  whether to use color coding in plots; green if
%                      constant, blue if dependent on the
%                      optimization variables, and red if affine.
%                      Default: 'nocolor'
% 'label', 'nolabel':  whether to print labels of array elements.
%                      Default: 'nolabel'
% 'print', 'noprint':  whether to use formatting suitable for
%                      printout. Default: 'noprint'
% 'stagger', 'nostagger': whether to stagger labels in 1-D plots
%                      readability
%         'FontSize':  font size of labels. To be followed the font
%                      size value.
%        'LineWidth':  Width of line used in stem plot. Followed by
%                      line width value.

plot(optArray(seq),varargin{:}) % the {:} allows varargin to be
                                % passed through untouched
