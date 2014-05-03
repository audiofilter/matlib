function new_born(in)

% NEW_BORN ....	Sample function representing number of new-born babies.
%
%    NEW_BORN(N) generates a sample function representing the daily number of 
%    		new-born babies in Toronto over a 90 day period.  
%    		The autocorrelation function of the sample "baby" function 
%    		is also plotted if the input argument N = 0.
%
%    NEW_BORN	When the function is used without an input argument, 
%		it will plot a sample only when you hit the RETURN key.
%
%    See also	TEMPERATURE

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
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

gset nokey;
y = randn(1,1092)*10 + 100;
y = fix(y);
x = y(1001:1092);
subplot(211), clearplot
axis([1 92 60 140]);                        ...
grid,                                       ...
xlabel('Time period: June 1 to August 31'), ...
ylabel('number of new borns'),              ...
title('NEW BORN');                          ...
plot(1,1);
hold on
if(nargin == 0)
  axis;
  for n=11:92
	for k=1:10
	   plot([1:k],x(1:k)); plot(k,x(k),'*');
	end
	yy = menu('OPTIONS','Plot ALL data & CLOSE this menu', ...
	          'Plot the NEXT data point', ... 
                  'CLOSE this menu');
	if (yy == 3)
	  break;
	elseif (yy == 2)
	  plot([1:n],x(1:n)); plot(n,x(n),'*');
	  if(n <31) 
	     fprintf('Number of new borns on June %3.0f is %6.0f.\n',n,x(n));
	  elseif(n < 62)
	     fprintf('Number of new borns on July %3.0f is %6.0f.\n',n-30,x(n));
	  else
	     fprintf('Number of new borns on Aug. %3.0f is %6.0f.\n',n-61,x(n));
	  end
	elseif (yy == 1)
      for k=1:92
         plot([1:k],x(1:k)); plot(k,x(k),'*');
      end
	  break;
	end
  end
else
  plot([1:92],x(1:92)); plot([1:92],x(1:92),'*');
  hold off
  ry = acf(y-mean(y),20,'norm');
  subplot(212), clearplot
  xlabel('Number of days'); ...
  ylabel('ACF');            ...
  title('NEW BORN');        ...
  axis;                     ...
  plot([-10:10],ry(11:31)), grid;
  hold off
end
hold off
