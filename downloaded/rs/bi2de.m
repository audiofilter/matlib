function d = bi2de(...)
##BI2DE Convert binary vectors to decimal numbers.
##   D = BI2DE(B) converts a binary vector B to a decimal value D. When B is a
##   matrix, the conversion is performed row-wise and the output D is a column
##   vector of decimal values. The default orientation of the of the binary
##   input is Right-MSB; the first element in B represents the least
##   significant bit.
##
##   In addition to the input matrix, two optional parameters can be given:
##
##   D = BI2DE(...,P) converts a base P vector to a decimal value.
##
##   D = BI2DE(...,FLAG) uses FLAG to determine the input orientation.  FLAG has
##   two possible values, 'right-msb' and 'left-msb'.  Giving a 'right-msb' FLAG
##   does not change the function's default behavior.  Giving a 'left-msb'
##   FLAG flips the input orientation such that the MSB is on the left.
##
##   Examples:
##   ¯ B = [0 0 1 1; 1 0 1 0];
##   ¯ T = [0 1 1; 2 1 0];
##
##   ¯ D = bi2de(B)      ¯ D = bi2de(B,'left-msb')      ¯ D = bi2de(T,3)
##   D =                 D =                            D =
##       12                   3                             12
##        5                  10                              5
##
##   See also DE2BI.

##   Copyright 1996-2000 The MathWorks, Inc.
##   $Revision: 1.1 $  $Date: 2003/02/07 13:04:23 $


## Typical error checking.
error(nargchk(1,3,nargin));

## --- Placeholder for the signature string.
sigStr = '';
flag = '';
p = [];

## --- Identify string and numeric arguments
va_start();
for i=1:nargin
  ## --- Assign the string and numeric flags
  arg=va_arg();
  if(isstr(arg))
    sigStr = strcat (sigStr, '/s');
  elseif(isnumeric(arg))
    sigStr = strcat (sigStr, '/n');
  else
    error('Only string and numeric arguments are accepted.');
  end
end

## --- Identify parameter signitures and assign values to variables
va_start();
switch sigStr
    ## --- bi2de(d)
  case '/n'
    b = va_arg();
    
    ## --- bi2de(d, p)
  case '/n/n'
    b = va_arg();
    p = va_arg();
    
    ## --- bi2de(d, flag)
  case '/n/s'
    b = va_arg();
    flag = va_arg();
    
    ## --- bi2de(d, p, flag)
  case '/n/n/s'
    b = va_arg();
    p = va_arg();
    flag = va_arg();
    
    ## --- bi2de(d, flag, p)
  case '/n/s/n'
    b = va_arg();
    flag = va_arg();
    p = va_arg();
    
    ## --- If the parameter list does not match one of these signatures.
  otherwise
    error('Syntax error.');
end

if isempty(b)
   error('Required parameter empty.');
end

if max(max(b < 0)) | max(max(~isfinite(b))) | (~isreal(b)) | (max(max(floor(b) ~= b)))
   error('Input must contain only finite real positive integers.');
end

## Set up the base to convert from.
if isempty(p)
    p = 2;
elseif max(size(p)) > 1
   error('Source base must be a scalar.');
elseif (floor(p) ~= p) | (~isfinite(p)) | (~isreal(p))
   error('Source base must be a finite real integer.');
elseif p < 2
   error('Source base must be greater than or equal to two.');
end

if max(max(b)) > (p-1)
   error('The elements of the matrix are larger than the base can represent.');
end

m = size(b,1);
n = size(b,2);

## If a flag is specified to flip the input such that the MSB is to the left.
if isempty(flag)
   flag = 'right-msb';
elseif ~(strcmp(flag, 'right-msb') | strcmp(flag, 'left-msb'))
   error('Invalid string flag.');
end

if strcmp(flag, 'left-msb')

   b2 = b;
   b = b2(:,n:-1:1);

end

## The actual conversion.
for i = 1:m                                         # Cycle through each row.
   highest = max(find(b(i,:))) - 1;
   if isempty(highest)
      d(i) = 0;                                     # If zero.
   elseif p^highest == Inf
      d(i) = Inf;                                   # If infinite.
   else
      d(i) = b(i,1:highest+1) * p.^[0 : highest]';  # The typical case.
   end
end

d = d(:);

## [EOF] bi2de.n
