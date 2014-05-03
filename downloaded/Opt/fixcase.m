function y=fixcase(x)

% y=fixcase(x)
% workaround for bug in PC/Windows version that requires lowercase references
% to class members.  Currently has no effect on other platforms.

if strcmp(computer,'PCWIN')
   y=lower(x);
else
   y=x;

