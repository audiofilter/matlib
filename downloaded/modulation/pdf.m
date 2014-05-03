function [pdf_out, x_out] = pdf(in,bin)

% PDF ......... computes and plots the sample probability density function.
%
%	PDF(X) plots the sample pdf of the input vector X with 100
%		equally spaced bins between the minimum and maximum 
%		values of the input vector X.
%	PDF(X,N), where N is a scalar, uses N bins.
%	PDF(X,N), where N is a vector, draws a pdf using the bins
%		specified in N.
%	[f,x] = PDF(...) does not plot the pdf, but returns vectors
%		f and x such that PLOT(x,f) is the sample pdf.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o   Added "checking"  11.30.1992 MZ
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%       o       Modified under OCTAVE 2.0.14 2000.08.12 
%===========================================================================

global START_OK;
global BELL;
global WARNING;

check;

%------------------------------------------------------------------------
%	Define parameters
%------------------------------------------------------------------------
nx_default = 100;
axis_default = 1;
%------------------------------------------------------------------------
%	Prepare absicca vector and other parameters
%------------------------------------------------------------------------
if ((nargin ~= 1) & (nargin ~= 2))
   error(eval('eval(BELL),eval(WARNING),help pdf'));
   return;
end   
if (nargin == 1)
    nx    = nx_default;
    max_x = nx_default;
else
    nx    = bin;
end
max_y = length(in);

[out,x] = hist(in,nx);
nx_aug  = [x,x(length(x))+(x(length(x))-x(length(x)-1))];

if ( length(out(out~=0)) <= 10 )	% Discrete distribution
    out  = out/max_y ;
    flag = 'discrete';
else					% Continuous distribution
    out  = (out ./ diff(nx_aug))/max_y ;
    flag = 'continuous';
end
%------------------------------------------------------------------------
%	Output routines
%------------------------------------------------------------------------
if (nargout == 0)
    axis_default = (max(x) - min(x))/2;
    xmin = min(x)-axis_default; xmax = max(x) + axis_default;
    if  strcmp(flag, 'discrete')
	delta = max(diff(x));
	nbin  = length(x);
	xa = [ (x(1)-delta/2), (x+delta/2) ];
	oa = [ out(1), 0, out(2:nbin) ];
	grid,       ...
%        if( strcmp(axis('state'),'auto') ), 
%            axis([xmin xmax 0 1.5*max(out)]); end; ...
        axis([xmin xmax 0 1.05*max(out)]); ...  % MODIF. OCTAVE
	title('Sample PDF'),               ...
	stairs(xa,oa); 
    elseif  strcmp(flag, 'continuous')
	grid,       ...
%       if( strcmp(axis('state'),'auto') ), 
%           axis([xmin xmax 0 1.5*max(out)]); end; ...
        axis([xmin xmax 0 1.05*max(out)]); ...
	title('Sample PDF'),               ...
	plot(x,out);
    end
elseif (nargout == 1)
    pdf_out = out;
else
    pdf_out = out;
    x_out   = x;
end
axis;
end

