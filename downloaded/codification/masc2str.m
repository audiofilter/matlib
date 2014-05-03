function [y] = masc2str(x,databits,parity,stopbits)
%MASC2STR Modem-ASCII to string conversion.
%       [Y] = MASC2STR(X) converts vector X containing 1's and
%       0's representing raw, eight-bit ASCII coding into a
%       string.
%
%       [Y] = MASC2STR(X,DATABITS,'PARITY',STOPBITS) converts
%       vector X containing 1's and 0's representing modem
%       encoded ASCII into a string.  The number of databits
%       can be 7 or 8. Parity can be 'n' for none, 'o' for odd,
%       or 'e' for even.  The number of stopbits can be 1 or 2.
%       One start bit is always used.  Valid combinations are:
%
%           7n1, 7e1, 7o1, 7n2, 7e2, 7o2, 8n1, 8n2
%
%       Errors in the binary stream are coded as:
%
%           * - startbit error
%           ~ - first stopbit error
%           ` - second stopbit error
%           + - parity error
%
%       Note: Parity errors take precedence over start/stop bit
%       errors.
%
%	Note: The bit stream must meet the specifications of
%	ANSI Standards X3.15 and X3.16 in that the start bit is a 
%	space, the stop bit(s) is a mark, and the data bits are 
%	ordered from least significant to most significant order.
%
%       See also STR2MASC

%       LT Dennis W. Brown 8-11-93, DWB 2-20-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% check args
if nargin ~= 1  &  nargin ~= 4,
    error('masc2str: Invalid number of arguments...');
end;
if isstr(x) | max(x) > 1 | min(x) < 0,
    error('masc2str: Argument 1 has to be a vector of 0''s and 1''s...');
end;

if nargin == 4,
    if databits ~= 7  &  databits ~= 8
        error('masc2str: Databits can only be 7 or 8...');
    end;

    parity = lower(parity);
    if parity ~= 'n'  &  parity ~= 'o'  &  parity ~= 'e',
        error('masc2str: Invalid parity (n,e,o)....');
    end;
    if databits == 8  & parity ~= 'n'
        error('masc2str: Only no parity is allowed with 8 databits...');
    end;

    if stopbits ~= 1  &  stopbits ~= 2
        error('masc2str: Only 1 or 2 stopbits are allowed...');
    end;
end;

% compute number of bits per character
if nargin == 1,
    databits = 8; parity = 'n'; stopbits = 0; nbrbits = 8;
    offset = 0;
else
    nbrbits = databits + ((parity == 'o') | (parity == 'e')) + stopbits + 1;
    offset = 1;
end;

% check length
if rem(x,nbrbits),
    disp('masc2str: Bits are missing, zero padding input vector...');
    x = [x ; zeros(ceil(x/nbrbits)*nbrbits - length(x),1)];
end;

% reshape to one character per row
y = zeros(length(x)/nbrbits,1);
x = reshape(x,nbrbits,length(x)/nbrbits)';

% convert to decimal
k = 0;
for i = (1:databits)+offset,
    y = y + x(:,i) * 2^k;
    k = k + 1;
end;

% check start bits
if nargin ~= 1,
    ff = find(x(:,1) == 1);
    y(ff) = ones(length(ff),1) * '*';
end;

% check stop bits
if nargin ~= 1,
    ff = find(x(:,offset+databits+(parity ~= 'n')+1) == 0);
    y(ff) = ones(length(ff),1) * '~';
    if stopbits == 2,
        ff = find(x(:,offset+databits+(parity ~= 'n')+1) == 0);
        y(ff) = ones(length(ff),1) * '`';
    end;
end;

% check parity
yp = zeros(length(y),1);
if parity == 'o'
    yp = ~rem(sum(x(:,offset+1:offset+databits)'),2)';
elseif parity == 'e',
    yp = rem(sum(x(:,offset+1:offset+databits)'),2)';
end;
if parity ~= 'n',
    ff = find(x(:,offset+databits+1) ~= yp);
    y(ff) = ones(length(ff),1) * '+';
end;

% convert to string
y = setstr(y');

