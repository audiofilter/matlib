function [y,h] = cntaxes(fig)
%CNTAXES Count axes objects.
%       [Y] = CNTAXES(FIGURE) counts the number of axes objects
%       in the figure window specified with the handle FIGURE.
%
%       [Y] = CNTAXES counts the number of axes objects
%       in the current figure window.
%
%       [Y,H] = CNTAXES(FIGURE) and [Y,H] = CNTAXES return a
%       vector containing the axes handles in H.
%
%       See also FIGURE, AXES

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% default
if nargin == 0, fig = gcf; end;

% check validity of handle given
if isempty(find(get(0,'Children') == fig)),
    error('cntaxes: Invalid figure window handle...');
end

% output variables
y = 0;
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'axes'), y = y + 1; end;
    if nargout == 2, h = [h ; c(i)]; end;
end;

