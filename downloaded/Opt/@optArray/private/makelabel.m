function varlabel = makelabel(seq, numfmt, printflag, qq)

global OPT_DATA;

h = get_h(seq); xoff = get_xoff(seq);
pool = get_pool(seq);

% determine letter to use for plot labels. Default is 'x'.
if strcmp(OPT_DATA.poolnames{pool}, '')
  vname = 'x';
else
  vname = OPT_DATA.poolnames{pool};
end

% assemble labels for the lollipops

% determine opt variables that current loc is based on
if xoff == -1   % if it's affine, ignore constants 
  varlocs = find([0;h(2:end,qq)]);
else
  varlocs = find(h(:,qq));
end

varlabel = '';
% do constant term first
if (h(1,qq) ~= 0) & (xoff==-1)
  if isreal(h(1,qq))
    varlabel = [num2str(h(1,qq), numfmt)];
  elseif (real(h(1,qq)) == 0) & (imag(h(1,qq)) == 1)
    varlabel = ['j'];
  elseif (real(h(1,qq)) == 0) & (imag(h(1,qq)) == -1)
    varlabel = ['-j'];
  elseif (real(h(1,qq)) == 0)
    varlabel = [num2str(imag(h(1,qq)), numfmt) 'j'];
  elseif imag(h(1,qq)) == 1
    varlabel = [num2str(real(h(1,qq)), numfmt) '+j'];
  elseif imag(h(1,qq)) == -1
    varlabel = [num2str(real(h(1,qq)), numfmt) '-j'];
  else
    varlabel = [num2str(h(1,qq), numfmt)];
  end
  if ~printflag
    varlabel = [varlabel ' '];
  end
  %if ~isempty(varlocs)    % if there are variables to add, add plus sign
  %  varlabel = [varlabel ' + '];
  %end
else
  varlabel = '';
end

% now do variable terms
if ~isempty(varlocs)
  for ss=1:length(varlocs)
    hvss = h(varlocs(ss),qq);
    if hvss == 1 % if the coeff is 1, don't print it
      if isempty(varlabel)
	% the check isempty(varlabel) here, and below, is to see if
        % a leading + should be printed
	;
      else
	if printflag
	  varlabel = [varlabel '+'];
	else
	  varlabel = [varlabel '+ '];
	end
      end
    elseif hvss == -1 % case: '-x'
      if printflag
	varlabel = [varlabel '-'];
      else
	varlabel = [varlabel '- '];
      end
    elseif (imag(hvss) == 1) & (real(hvss) == 0) % case: 'jx'
      if isempty(varlabel)
	varlabel = [varlabel 'j'];
      else
	if printflag
	  varlabel = [varlabel '+j'];
	else
	  varlabel = [varlabel '+ j'];
	end
      end
    elseif (imag(hvss) == -1) & (real(hvss) == 0) % case: '-jx'
      if printflag
	varlabel = [varlabel '-j'];
      else
	varlabel = [varlabel '- j'];
      end
    elseif (imag(hvss) == 1) % case: '(a+j)x'
      if ~isempty(varlabel)
	if printflag
	  varlabel = [varlabel '+'];
	else
	  varlabel = [varlabel '+ '];
	end
      end
      varlabel = [varlabel '(' num2str(real(hvss)) '+j)'];
    elseif (imag(hvss) == -1) % case: '(a-j)x'
      if ~isempty(varlabel)
	if printflag
	  varlabel = [varlabel '+'];
	else
	  varlabel = [varlabel '+ '];
	end
      end
      varlabel = [varlabel '(' num2str(real(hvss)) '-j)'];
    elseif (real(hvss) == 0) & (imag(hvss) ~= 1)
      if imag(hvss) < 0 % case: '-bjx'
	if printflag
	  varlabel = [varlabel '-'];
	else
	  varlabel = [varlabel '- '];
	end
	varlabel = [varlabel num2str(abs(imag(hvss))) 'j'];
      else % case: 'bjx'
	if isempty(varlabel)
	  varlabel = [varlabel num2str(imag(hvss)) 'j'];
	else
	  if printflag
	    varlabel = [varlabel '+' num2str(imag(hvss)) 'j'];
	  else
	    varlabel = [varlabel '+ ' num2str(imag(hvss)) 'j'];
	  end
	end
      end
    elseif ~isreal(hvss) % case: '(a+bj)x'
      if ~isempty(varlabel)
	if printflag
	  varlabel = [varlabel '+'];
	else
	  varlabel = [varlabel '+ '];
	end
      end
      varlabel = [varlabel '(' num2str(hvss) ')'];                
    else
      if real(hvss) < 0 % case: '-ax'
	if printflag
	  varlabel = [varlabel '-' num2str(abs(hvss))];
	else
	  varlabel = [varlabel '- ' num2str(abs(hvss))];
	end
      else % case: 'ax'
	if ~isempty(varlabel)
	  if printflag
	    varlabel = [varlabel '+'];
	  else
	    varlabel = [varlabel '+ '];
	  end
	end
	varlabel = [varlabel  num2str(hvss)];
      end
    end

    varlabel = [varlabel vname '_{' num2str(xoff+varlocs(ss)) '}'];
    if ~printflag
      varlabel = [varlabel ' '];
    end
    % next
  end
end

