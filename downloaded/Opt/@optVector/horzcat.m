function [c]=horzcat(varargin)
% OPTVECTOR/HORZCAT  horizontal concatenation
% [c] = horzcat(a,b, ...)
%  c = [a, b, ...]
% a, b, ... should be of type optVector

% for now, just call vertcat
c=vertcat(varargin{:});
