function indexext = getextr (v, rand)
% function indexext = getextr (v, rand)
%
% Determination of alternating extremal points in the vector v. For adjacent
% extremal points with identical sign the program returns only the maximum.
%  
% Input:
%            v         interesting vector
%            bound     = 1 --> include boundaries
%                      = 0 --> ignore boundaries
%
% Output:
%            indexext  indices of the extremal points
%
% Author:    Frank Westerkowsky and
%            Markus Lang  <lang@jazz.rice.edu>, jun-23-1992
%

% Copyright: All software, documentation, and related files in this
%            distribution are Copyright (c) 1992 LNT, University of Erlangen
%            Nuernberg, FRG, 1992 
%
% Permission is granted for use and non-profit distribution providing that this
% notice be clearly maintained. The right to distribute any portion for profit
% or as part of any commercial product is specifically reserved for the author.
%
% Since this program is free of charge we provide absolutely no warranty.
% The entire risk as to the quality and the performance of the program is
% with the user. Should it prove defective, the user user assumes the cost
% of all necessary serrvicing, repair or correction. 

%ind3 = zeros(1,1);
%ind2 = zeros(1,1);


dv = diff (v);                                    % Ableitung von v ...
lv = length (v);                                  % ... und Laenge davon

% Auffinden der Vorzeichenwechsel ohne dazwischenliegendes Nullelement von dv
x = 1 : (length(dv)-1);
nullv = find ((sign(dv(x)) ~= sign(dv(x+1))) & sign(dv(x)) & sign(dv(x+1)));

% Nullstellen von dv bestimmen und nebeneinanderliegende bis auf jeweils eine aussortieren
null0 = find (dv == 0);
null = [];
akku = 0;
z    = 0;
for x = 1 : length(null0);
   if (x < length(null0));
      if ((null0(x+1) - null0(x)) == 1);
         akku = akku + null0(x);
         z    = z + 1;
      end;	 
   elseif (z);
      null = [null fix((akku+null0(x)) / (z+1))];	  
	  akku = 0;
	  z    = 0;
   else
      null = [null null0(x)];
   end;
end;

% Elemente aufsteigend sortieren
indexext = sort ([nullv null0]) + 1;


% Randextrema einbeziehen
  if (rand);
    if (dv(1)); 
      indexext = [1 indexext];
    end;
    if (dv(lv-1));
      indexext = [indexext lv];
    end;
  end;   	  

% Ueberpruefung der Alternantenbedingung:
%
l = length(indexext);
% Existieren vorzeichengleiche aufeinanderfolgende Extrema?
ind = find(sign(v(indexext(1:l-1)))==sign(v(indexext(2:l))));
if length(ind)>0                                 % finde deren Indizes
  pointer = 0;  counter1 = 0;  counter2 = 0;  ind1 = []; ind2 = [];
  for i=1:l-1
    if sign(v(indexext(i)))==sign(v(indexext(i+1)));
      ind1 = [ind1 i i+1];
      ind2 = [ind2 indexext(i) indexext(i+1)];
      if pointer~=1;  counter2 = counter2 + 1; 
         counter1(counter2) = 0;   
      end
      counter1(counter2) = counter1(counter2) + 1;
      pointer = 1;
    else
      pointer = 0;
    end
  end

% Entferne doppelt auftauchende Indizes
  lh = length(ind1); ind1 = sort(ind1);
  indh = find(ind1(1:lh-1)==ind1(2:lh));
  ind1(indh+1) = [];

% Entferne doppelt auftauchende Indizes
  lh = length(ind2); ind2 = sort(ind2);
  indh = find(ind2(1:lh-1)==ind2(2:lh));
  ind2(indh+1) = [];


  counter3 = 1;  
% Bestimme jeweils das Maximum der vorzeichengleichen Extrema
ind3 = [];
  for i=1:counter2;
    indh = ind2(counter3:counter3+counter1(i));
    [maximum,ind_max] = max(abs(v(indh)));
    indh = ind1(counter3:counter3+counter1(i));
    indh(ind_max) = [];
    ind3 = [ind3 indh];
    counter3 = counter3 + counter1(i) + 1;
  end
  ind3 = sort(ind3);
  indexext((ind3)) = [];
end

% Entferne doppelt auftauchende Indizes
l_ind = length(indexext);
indh = find(indexext(1:l_ind-1)==indexext(2:l_ind));
indexext(indh+1) = [];

%n = 1:lv;
%plot(n, v, n(indexext), v(indexext),'o');
%keyboard
