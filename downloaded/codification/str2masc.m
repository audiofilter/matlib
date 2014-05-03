function [y] = str2masc(string,databits,parity,stopbits)
%STR2MASC String to modem-ASCII conversion.
%       [Y] = STR2MASC('STRING') - Converts STRING to a vecto
%       r of 1's and 0's representing raw, eight-bit ASCII coding.
%
%       [Y] = STR2MASC('STRING',DATABITS,'PARITY',STOPBITS)
%       converts STRING to a vector of 1's and 0's representing
%       modem encoded ASCII.  The number of databits can be 7
%       or 8.  Parity can be 'n' for none, 'o' for odd, or 'e'
%       for even.  The number of stopbits can be 1 or 2.
%       One start bit is always used.  Valid combinations are:
%
%           7n1, 7e1, 7o1, 7n2, 7e2, 7o2, 8n1, 8n2
%
%	Note: The bit stream produced meets the specifications of
%	ANSI Standards X3.15 and X3.16 in that the start bit is a 
%	space, the stop bit(s) is a mark, and the data bits are 
%	ordered from least significant to most significant order.
%
%       See also MASC2STR


%       LT Dennis W. Brown 8-11-93, DWB 2-20-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% check args
if nargin ~= 1  &  nargin ~= 4,
    error('str2masc: Invalid number of arguments...');
end;
if ~isstr(string),
    error('str2masc: Argument 1 has to be a string...');
end;
if nargin == 4,
    if databits ~= 7  &  databits ~= 8
        error('str2masc: Databits can only be 7 or 8...');
    end;

    parity = lower(parity);
    if parity ~= 'n'  &  parity ~= 'o'  &  parity ~= 'e',
        error('str2masc: Invalid parity (n,e,o)....');
    end;
    if databits == 8  & parity ~= 'n'
        error('str2masc: Only no parity is allowed with 8 databits...');
    end;

    if stopbits ~= 1  &  stopbits ~= 2
        error('str2masc: Only 1 or 2 stopbits are allowed...');
    end;
end;

% compute number of bits per character
if nargin == 1,
    databits = 8; parity = 'n'; stopbits = 0;
    offset = 0;
    y = zeros(8,length(string));
else
    nbrbits = databits + ((parity == 'o') | (parity == 'e'));
    y = [zeros(1,length(string));zeros(nbrbits,length(string)); ones(stopbits,length(string))];
    offset = 1;
end;

% convert string to decimal
% z = abs(string);
z = toascii(string); % MODIF. OCTAVE

% convert to binary
for i = databits:-1:1,

    y(offset+i,:) = floor(z ./ 2^(i-1));

    z = rem(z,2^(i-1));

end;

% compute parity
if parity == 'o'
    y(offset+databits+1,:) = ~rem(sum(y(offset+1:offset+databits,:)),2);
elseif parity == 'e',
    y(offset+databits+1,:) = rem(sum(y(offset+1:offset+databits,:)),2);
end;

y = y(:);
if(size(y,2)==1) y=y'; end;  % MODIF. OCTAVE

