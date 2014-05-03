function fcn = qm(minterms, numvars)
% QM Minimal Sum-of-Products form
%
% FCN = QM(MINTERMS, NUMVARS) reduces the Boolean function
% expressed by MINTERMS into the minimal sum-of-products form using the
% Quine-McCluskey method. FCN is a cell array of essential prime
% implicant terms. Terms are expressed as arrays of indices-- so 1 
% indicates the least significant variable, and so on. A negative
% index indicates a complemented variable.
%
% Example:
% a result of {[1 -4]; [-3]; [2 5]}
% indicates the minimized function is
%    F(a,b,c,d,e) = ad' + c' + be
% for 'a' being the LSV, and so on.

if any(minterms >= 2^numvars)
  error('invalid minterm')
end

% STEP 1 --- FIND PRIME IMPLICANTS

pow2tbl = 2.^[0:numvars];
minterms = unique(minterms(:));
binterms = dec2bin(minterms);
groups = cell(numvars+1, numvars+1); % cell array to hold groupings
% Columns of the groups array correspond to the number of
% iterations of the prime implicant selection algorithm.
% Rows of the groups array correspond to the groupings of minterms
% of the algorithm.

for qq=1:length(minterms)
  % determine number of ones in each minterm's binary representation
  numones(qq) = length(find(binterms(qq,:)=='1'));
  groups{numones(qq)+1,1} = [ groups{numones(qq)+1,1}; minterms(qq) ];
end

for qq=1:numvars
  tbd = [];
  for zz=1:numvars
    curgroup = groups{zz,qq};
    nextgroup = groups{zz+1, qq};
    termcomb = [];
    % curgroup is current group of minterms to inspect.
    for kk=1:size(curgroup,1)
      for hh=1:size(nextgroup,1)
	      %iswhole(log2(nextgroup(hh,1) - curgroup(kk,1))) & ...
	if (nextgroup(hh,1) > curgroup(kk,1)) & ...
	      any(pow2tbl == nextgroup(hh,1)-curgroup(kk,1)) & ...
	      all(nextgroup(hh,:) - curgroup(kk,:) == ...
		  nextgroup(hh,1) - curgroup(kk,1))
	  % conditions to combine terms: all minterm numbers are
          % greater, the differences between terms are all the same
          % power of 2
	  tbd = [tbd; zz kk; zz+1 hh];
	  % add to list of eliminated terms
	  %termcomb = sort([curgroup(kk,:) nextgroup(hh,:)]);
	  termcomb = [termcomb; curgroup(kk,:) nextgroup(hh,:)];
	  %groups{zz, qq+1} = unique([groups{zz, qq+1}; termcomb], 'rows');
	end
      end
    end
    groups{zz, qq+1} = unique(sort(termcomb,2),'rows');
  end
  tbd = unique(tbd, 'rows');
  for mm=size(tbd,1):-1:1
    % cleanup loop -- eliminate unneeded terms 
    % Run the loop backwards so that data is deleted off the end
    curgroup = groups{ tbd(mm,1), qq };
    curgroup(tbd(mm,2),:) = [];
    groups{ tbd(mm,1), qq} = curgroup;
  end
end

numPI = 0; % keep track of number of prime implicants
groups = reshape(groups, prod(size(groups)), 1); % flatten cell array
for qq=length(groups):-1:1
  if isempty(groups{qq})
    groups(qq) = [];
  else
    numPI = numPI + size(groups{qq},1);
  end
end

% STEP 2 --- FIND ESSENTIAL PRIME IMPLICANTS

% skipidx allows for quick indexing through the list of prime
% implicants, which is still stored in the cell array groups
skipidx = [1; zeros(length(groups)-1,1)];
for qq=2:length(groups)
  skipidx(qq) = skipidx(qq-1) + size(groups{qq-1},1);
end
keepidx = logical(zeros(numPI,1));
mintermidx = logical(zeros(1,length(minterms)));

% form prime implicant table
EPI = logical(zeros(numPI, length(minterms)));
%EPI = false(numPI, length(minterms)); % works only in MATLAB R13
row = 1;
for qq=1:length(groups)
  for zz=1:size(groups{qq},1)
    for kk=1:length(minterms)
      EPI(row , kk) = any(groups{qq}(zz,:) == minterms(kk));
    end
    row = row+1;
  end
end

% determine which minterms remain to be covered after selecting
% essential prime implicants.
for qq=1:numPI
  cover = find(EPI(:,qq));
  if length(cover) == 1
    keepidx(cover) = logical(1);
    mintermidx(find(EPI(cover,:))) = logical(1);
  end
end

if any(~mintermidx)
  % if we don't have a clear way to further minimize the function,
  % just use all of the prime implicants.
  % It is possible to further minimize, but may involve testing all
  % subsets of the non-essential prime implicants. It's probably
  % not so beneficial to do this.
  keepidx(:) = logical(1);
end

% STEP 3 --- SPECIFY TERMS OF RESULT

keeps = find(keepidx);
fcn = cell(1, length(keeps));
for qq=1:length(groups)
  for zz=1:size(groups{qq},1)
    keepthis = any(find(keeps == zz+skipidx(qq)-1));
    if keepthis
      bins = dec2bin( groups{qq}(zz,:), numvars );
      bins = double(bins)-48; % convert to array of ones and zeros
      % subtract 48, the ascii code of '0'
      sumbins = sum(bins,1); % sum of columns
      cares0 = find(sumbins == 0);
      cares1 = find(sumbins == size(bins,1));
      % trick: to determine the term in variable form, e.g. w'xy'z,
      % convert the minterm numbers to binary form and add. If the
      % sum of a particular column is not either 0 or the number of
      % minterms combined, it means this column is a don't care,
      % and the variable it corresponds to does not appear in the
      % final expression. If the column was all 0's, the
      % corresponding variable is complemented. If the column was
      % all 1's, the variable is uncomplemented.
      curterm = [-cares0 cares1];
      [devnull, I] = sort(abs(curterm));
      curterm = curterm(I); % to get the terms in order
      fcn{find(keeps == zz+skipidx(qq)-1)} = curterm;
    end
  end
end

