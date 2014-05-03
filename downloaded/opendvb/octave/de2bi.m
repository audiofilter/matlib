function b = de2bi(...)
##DE2BI Convert decimal numbers to binary numbers.
##   B = DE2BI(D) converts a nonnegative integer decimal vector D to a binary
##   matrix B. Each row of the binary matrix B corresponds to one element of D.
##   The default orientation of the of the binary output is Right-MSB; the first
##   element in B represents the lowest bit.
##
##   In addition to the vector input, three optional parameters can be given:
##
##   B = DE2BI(...,N) uses N to define how many digits (columns) are output.
##
##   B = DE2BI(...,N,P) uses P to define which base to convert the decimal
##   elements to.
##
##   B = DE2BI(...,FLAG) uses FLAG to determine the output orientation.  FLAG
##   has two possible values, 'right-msb' and 'left-msb'.  Giving a 'right-msb'
##   FLAG does not change the function's default behavior.  Giving a 'left-msb'
##   FLAG flips the output orientation to display the MSB to the left.
##
##   Examples:
##   � D = [12; 5];
##
##   � B = de2bi(D)                  � B = de2bi(D,5)
##   B =                             B =
##        0     0     1     1             0     0     1     1     0
##        1     0     1     0             1     0     1     0     0
##
##   � T = de2bi(D,[],3)             � B = de2bi(D,5,'left-msb')
##   T =                             B =
##        0     1     1                   0     1     1     0     0
##        2     1     0                   0     0     1     0     1
##
##   See also BI2DE.

##   Copyright 1996-2000 The MathWorks, Inc.
##   $Revision: 1.2 $  $Date: 2003/02/07 13:04:23 $

## Typical error checking.
error(nargchk(1,4,nargin));

## --- Placeholder for the signature string.
sigStr = '';
flag = '';
p = [];
n = [];

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
end;

## --- Identify parameter signitures and assign values to variables
va_start();
switch sigStr
    ## --- de2bi(d)
  case '/n'
    d = va_arg();
    
    ## --- de2bi(d, n)
  case '/n/n'
    d = va_arg();
    n = va_arg();

    ## --- de2bi(d, flag)
  case '/n/s'
    d = va_arg();
    flag = va_arg();
    
    ## --- de2bi(d, n, flag)
  case '/n/n/s'
    d = va_arg();
    n = va_arg();
    flag = va_arg();
    
    ## --- de2bi(d, flag, n)
  case '/n/s/n'
    d = va_arg();
    flag = va_arg();
    n = va_arg();
    
    ## --- de2bi(d, n, p)
  case '/n/n/n'
    d = va_arg();
    n = va_arg();
    p = va_arg();
    
    ## --- de2bi(d, n, p, flag)
  case '/n/n/n/s'
    d = va_arg();
    n = va_arg();
    p = va_arg();
    flag = va_arg();
    
    ## --- de2bi(d, n, flag, p)
  case '/n/n/s/n'
    d = va_arg();
    n = va_arg();
    flag = va_arg();
    p = va_arg();
    
    ## --- de2bi(d, flag, n, p)
  case '/n/s/n/n'
    d = va_arg();
    flag = va_arg();
    n = va_arg();
    p = va_arg();
    
    ## --- If the parameter list does not match one of these signatures.
  otherwise
    error('Syntax error.');
end

if isempty(d)
  error('Required parameter empty.');
end

d = d(:);
len_d = length(d);

if max(max(d < 0)) | max(max(~isfinite(d))) | (~isreal(d)) | (max(max(floor(d) ~= d)))
   error('Input must contain only finite real positive integers.');
end

## Assign the base to convert to.
if isempty(p)
    p = 2;
elseif max(size(p) ~= 1)
   error('Destination base must be scalar.');
elseif (~isfinite(p)) | (~isreal(p)) | (floor(p) ~= p)
   error('Destination base must be a finite real integer.');
elseif p < 2
   error('Cannot convert to a base of less than two.');
end;

## Determine minimum length required.
tmp = max(d);
if tmp ~= 0 				# Want base-p log of tmp.
   ntmp = floor( log(tmp) / log(p) ) + 1;
else 							# Since you can't take log(0).
   ntmp = 1;
end

## This takes care of any round off error that occurs for really big inputs.
if ~( (p^ntmp) > tmp )
   ntmp = ntmp + 1;
end

## Assign number of columns in output matrix.
if isempty(n)
   n = ntmp;
elseif max(size(n) ~= 1)
   error('Specified number of columns must be scalar.');
elseif (~isfinite(n)) | (~isreal(n)) | (floor(n) ~= n)
   error('Specified number of columns must be a finite real integer.');
elseif n < ntmp
   error('Specified number of columns in output matrix is too small.');
end

## Check if the string flag is valid.
if isempty(flag)
   flag = 'right-msb';
elseif ~(strcmp(flag, 'right-msb') | strcmp(flag, 'left-msb'))
   error('Invalid string flag.');
end

## Initial value.
b = zeros(len_d, n);

## Perform conversion.
for i = 1 : len_d                   # Cycle through each element of the input vector/matrix.
    j = 1;
    tmp = d(i);
    while (j <= n) & (tmp > 0)      # Cycle through each digit.
        b(i, j) = rem(tmp, p);      # Determine current digit.
        tmp = floor(tmp/p);
        j = j + 1;
    end;
end;

## If a flag is specified to flip the output such that the MSB is to the left.
if strcmp(flag, 'left-msb')

   b2 = b;
   b = b2(:,n:-1:1);

end

## [EOF] de2bi.m

