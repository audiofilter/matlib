function [a,b]=dart(mu,var,n,k)

% DART	visual depiction of the results from a simulated dart game.
%
%	DART( [mean_x mean_y], [var_x var_y], N, K )	
%		[ mean_x mean_y ] .. : x and y coordinates representing the mean
%			               (average) performance of the dart player.
%		[ var_x var_y ] .... : variance in x and y directions.
%		N .................. : number of darts thrown at the target.
%		K .................. : wait 1 second between each throw (def=0).
%
%		Target is the origin of the polar plane.
%		Each simulation result is displayed as a point (Theta,R) in the
%		polar plane where R = sqrt(X^2 + Y^2) and Theta = atan(Y/X)
%		where X ~ GAUSS(mean_x,var_x) and Y ~ GAUSS(mean_y,var_y).
%
%	REMARK: The display is limited to the interval [-1,1] x [-1 1];
%		therefore, select mean and variance values accordingly.
%
%	[Theta,R] = DART( ... ) will return the simulated phase and range 
%		in addition to displaying the simulation results.  Note that
%		if X and Y are Gaussian random variables, then R will have
%		Rayleigh distribution and Theta ~ U(-pi/2, pi/2).

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

%--------------------------------------------------------------------------
%	Input parameter control
%--------------------------------------------------------------------------
if (nargin ~= 3) & (nargin ~= 4)
   error(eval('eval(BELL),eval(WARNING),help dart'));
   return;
end   
s_mu     = sort(size(mu));
s_var    = sort(size(var));

if ( (s_mu(1) ~= 1) | (s_var(1) ~= 1) | (s_mu(2) ~= 2) | (s_var(2) ~= 2) )
   error('Input parameters of of incorrect dimensions.');
end

if (nargin == 3)
   p_time = 0;			% default pause time.
else
   p_time = min(1,k);		% wait 1 second between each throw
end
%--------------------------------------------------------------------------
%	Generate x and y parameters
%--------------------------------------------------------------------------
x = gauss(mu(1),var(1),n);
y = gauss(mu(2),var(2),n);

%--------------------------------------------------------------------------
%	Compute RANGE and ANGLE
%--------------------------------------------------------------------------
r = sqrt(x.^2 + y.^2);
t = atan((y+eps)./(x+eps));
t(x<0) = t(x<0) + pi;

%--------------------------------------------------------------------------
%	Let us start displaying the simulation results
%--------------------------------------------------------------------------
%polar1(0,0,'x'),
polar(0,0,"*"),           ...   % First the target with an 'x'
grid, hold on,            ...
title('DART BOARD'),      ...
xlabel('X'), ylabel('Y'), ...
plot([-1.05,1],[-1,-1],'-'), plot([-1.05,1],[1,1],'-'), ...
plot([-1,-1],[-1.05,1],'-'), plot([1,1],[-1.05,1],'-'), ...
plot([0,0],[-1.05,-1],'-'), plot([-1.05,-1],[0,0],'-'); 
%text(-1.2,-1,'-1'); text(-1.2,0,'0'); text(-1.2,1,' 1'); ...
%text(-1,-1.12,'-1'); text(0,-1.12,'0'); text(1,-1.12,'1'); 

for i=1:n
%    polar1(t(i),r(i),'o'); pause(p_time) 
     polar(t(i),r(i),'*'); pause(p_time); % Now the darts with 'o'
end

if (nargout ~= 0)
   x = (x - mu(1))/sqrt(var(1));
   y = (y - mu(2))/sqrt(var(2));
   a = atan((y+eps)./(x+eps));
   b = sqrt(x.^2 + y.^2);
end

hold off
