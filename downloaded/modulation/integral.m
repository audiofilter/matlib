function monte_carlo_integration( f, xin, n )

% INTEGRAL ....	Demonstration routine for Monte-Carlo based integration
%
%	INTEGRAL( f, [x1 x2], N ) evaluates the integral of function "f" over
%		the interval from x1 to x2 using a Monte-Carlo simulation
%		with N sample points.  The function "f" must be specified as
%		a string variable and as a function of "x".  For example:
%		INTEGRAL('x.^2',[0 1],1000) integrates the function x^2 over
%		the interval [0,1] using 1000 sample points.  
%
%		Several functions are available through the use of Matlab 
%		function FX_MENU.  Try INTEGRAL('f(x)',[x1 x2],5000).
%
%		REMARK: Use sample points less than 20000.  This function is
%			for demonstration purposes; absolute accuracy is not 
%			what we want to achieve here.
%
%	See also FX.

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
%===========================================================================

global START_OK;
global BELL;
global WARNING;

global MENU_x;
global MENU_min_x;
global MENU_max_x;
global MENU_n;

check;

%------------------------------------------------------------------------
%	Default values
%------------------------------------------------------------------------
max_points = 20000;
%------------------------------------------------------------------------
%	First check input parameters
%------------------------------------------------------------------------
if (nargin ~= 3)
   error(eval('eval(BELL),eval(WARNING),help integral'));
   return;
end   
if ( (size(xin) ~= [1 1]) | (xin(2) < xin(1)) )
   error('Integration limits are not correctly specified.');
end
if (n > max_points)
   fprintf('Number of similations will be restricted to %5.0f.\n',max_points);
   n = min(n,max_points);	
end
%------------------------------------------------------------------------
%	Generate random (x,y) pairs.
%------------------------------------------------------------------------

min_x = min(xin); 
max_x = max(xin);
x  = uniform(min_x,max_x,n);

MENU_x     = x;
MENU_min_x = min_x;
MENU_max_x = max_x;
MENU_n     = n;

if( strcmp(f,'f(x)') )
	fx_menu;
else
	mc_int( f );
end
