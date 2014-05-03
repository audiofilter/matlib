function check

% CHECK .........	Checks whether the global variables have been
%                   initialized or not.   If they are not set then
%                   will issue the initialization command "start"
%                   allowing the user to enter the experiment number
%                   before returning the control to the calling function.

%	AUTHOR :  M. Zeytinoglu
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : November 1992.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

%-----------------------------------------
%  if "start" has been called before 
%    START_OK = 2,
%  else 
%    START_OK = 0
%-----------------------------------------

check=0;
global START_OK 

if ( exist('START_OK') )
   if(START_OK==2) check=1;  % MODIF. OCTAVE
   else check=0              % MODIF. OCTAVE
   end
else check=0;
end

if (check==1)
  return;

else

eval('fprintf(''\a\a\a'')');  % MODIF. OCTAVE
% eval('fprintf(''\007\007\007'')');

disp(' ');
disp('********************************************************************');
disp('*                                                                  *');
disp('*   Please initiliaze global variables first.  You will now be     *');
disp('*   be prompted to enter the experiment number.   Enter the        *');
disp('*   experiment number and these variables will be set for you.     *');
disp('*                                                                  *');
disp('*   Please read page 11 in the User''s Manual on how to initialize  *');
disp('*   the simulation environment.                                    *');
disp('*                                                                  *');
disp('********************************************************************');
disp(' ');

  start;

end
