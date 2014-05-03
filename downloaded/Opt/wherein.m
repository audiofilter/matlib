function map = wherein(x,y)
%WHEREIN 
% if x and y are sets of unique numbers (or n-tuples), 
% wherein(x,y) returns vector of the locations
% in x of the entries of y.
% returns NaN if an entry of y is not found in x

if (size(x,2) == 1) & (size(y,2) == 1)
    % x and y are vectors; use vector version   
    map = zeros(length(y),1);
    for qq=1:length(y)
        mm = find( abs(x-y(qq)) < 10*eps );
        if isempty(mm)
            map(qq) = NaN;
        else 
            map(qq) = mm;
        end
    end;    
elseif size(x,2) == size(y,2)
    map = zeros(size(y,1),1);
    for qq=1:size(y,1)
        mm = find( any(x-repmat( y(qq,:) , size(x,1) , 1) ,2) < 10*eps );
        if isempty(mm)
            map(qq) = NaN;
        else 
            map(qq) = mm;
        end
    end;
else
  error('size mismatch')
end
