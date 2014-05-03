function plot(seq, varargin)
% OPTARRAY/PLOT     Graphical representation of optArray
%   plot(seq) plots optArray seq.
%   plot(seq, ...) plots seq with comma-separated list 
%       of plotting options.
%       options can be one or more of:
%  'color, 'nocolor':  whether to use color coding in plots; green if
%                      constant, blue if dependent on the
%                      optimization variables, and red if affine.
%                      Also, whether to plot a star for complex
%                      values and circle for real value, or only
%                      circles.
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
%       'MarkerSize':  Size of marker in stem plots.
%
%   PLOT calls appropriate function based on dimensionality of seq;
%   could be plot1, plot2 or plot3

if isempty(seq)
  error('optArray is empty.');
end

if size(seq.locs, 2) > 3
    error('Can only plot 1-D, 2-D or 3-D arrays.');
end

colorflag = logical(0); printflag = logical(0);
labelflag = logical(0); staggerflag = logical(1); % defaults
fontsize = []; linewidth = []; markersize = []; % defaults
qq=1;
while qq<=length(varargin)
  if ischar(varargin{qq})
    switch lower(varargin{qq})
     case {'color', 'c'}
      colorflag = logical(1);
     case 'nocolor'
      colorflag = logical(0);
     case 'label'
      labelflag = logical(1);
     case 'nolabel'
      labelflag = logical(0);
     case 'print'
      printflag = logical(1);
     case 'noprint'
      printflag = logical(0);
     case 'stagger'
      staggerflag = logical(1);
     case 'nostagger'
      staggerflag = logical(0);
     case 'fontsize'
      qq = qq+1;
      % for options with argument, advance counter to varargin
      if qq>length(varargin)
	error('FontSize must be followed by font size value.');
      end
      fontsize = varargin{qq};
      if prod(size(fontsize)) ~= 1
	error('FontSize must be a scalar.');
      end
      if ~isnumeric(fontsize)
	error('FontSize must be followed by font size value.');
      end
      if (fontsize <= 0) | ~isreal(fontsize)
	error('font size must be real and positive');
      end
     case 'linewidth'
      qq = qq+1;
      if qq>length(varargin)
	error('LineWidth must be followed by line width value.');
      end
      linewidth = varargin{qq};
      if prod(size(linewidth)) ~= 1
	error('LineWidth must be a scalar.');
      end
      if ~isnumeric(linewidth)
	error('LineWidth must be followed by line width value.');
      end
      if (linewidth <= 0) | ~isreal(linewidth)
	error('line width must be real and positive');
      end
     case 'markersize'
      qq = qq+1;
      if qq>length(varargin)
	error('MarkerSize must be followed by marker size value.');
      end
      markersize = varargin{qq};
      if prod(size(markersize)) ~= 1
	error('MarkerSize must be a scalar.');
      end
      if ~isnumeric(markersize)
	error('MarkerSize must be followed by marker size value.');
      end
      if (markersize <= 0) | ~isreal(markersize)
	error('marker size must be real and positive.');
      end
     otherwise
      error('unknown option to PLOT');
    end
  else
    error('options must be strings');
  end
  qq = qq + 1;
end

%feval(['plot' num2str(size(seq.locs, 2)) 'd'], seq, colorflag, ...
%      labelflag, printflag, fontsize, linewidth);

switch size(seq.locs, 2)
 case 1
  plot1d(seq, colorflag, labelflag, printflag, staggerflag, ...
	 fontsize, linewidth, markersize);
 case 2
  plot2d(seq, colorflag, labelflag, printflag, ...
	 fontsize, linewidth, markersize);
 case 3
  plot3d(seq, colorflag, labelflag, printflag, ...
	 fontsize, linewidth, markersize);
 otherwise
  error('can only plot 1, 2, or 3-D arrays');
end

% fancy way of calling correct plot function: plot1d, plot2d, plot3d
