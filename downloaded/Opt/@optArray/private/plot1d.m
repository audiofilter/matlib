function plot1d(seq, colorflag, labelflag, printflag, staggerflag, ...
		fontsize, linewidth, markersize) 
% OPTARRAY/PLOT1D Graphical representation of optArray

if size(seq.locs, 2) ~= 1
  error('Can only plot 1-D arrays.');
end

flag = 1;
if isconst(seq)         % if it's constant, just plot heights, no labels
  h = get_h(seq);
  if any(~isreal(h))
    %error ('Cannot plot complex sequences.')
    warning ('Imaginary parts of complex terms ignored.');
  end
  style = '';
  if colorflag    % if color coding is desired
    if printflag  % if paper-ready is desired
      style = [style 'k'];
    else
      style = [style 'g'];
    end
  end
  stemhand = stem(seq.locs, real(full(h)), style, 'filled');
  if ~isempty(linewidth)
    set(stemhand(2), 'LineWidth', linewidth); % stems
    set(stemhand(1), 'LineWidth', linewidth); % heads
  end
  if ~isempty(markersize)
    set(stemhand(1), 'MarkerSize', markersize);
  end
  %set(stemhand(1), 'MarkerFaceColor', 'm');
  xlims = [min(seq.locs)-0.25*abs(min(seq.locs)) ...
	   max(seq.locs)+0.25*abs(max(seq.locs)) ];
  ylims = [min([0 min(real(h))+0.25*min(real(h))]) ...
	   max(real(h))+0.25*max(real(h))]; 
  xlims = get(gca, 'XLim');
  ylims = get(gca, 'YLim');
  ylims(1) = ylims(1) - 0.25*abs(ylims(1));
  ylims(2) = ylims(2) + 0.25*abs(ylims(2));
  xlims(1) = xlims(1) - 0.25*abs(xlims(1));
  xlims(2) = xlims(2) + 0.25*abs(xlims(2));
  axis([xlims ylims])

else
  h = get_h(seq);
  xoff = get_xoff(seq);
  
  % place height-1 lollipops at time locations dependent on vars    
  if xoff == -1
    stemhts = double(any(h(2:end,:)));
    constidx = find(h(1,:));
    if isempty(constidx)
      constidx = NaN;  % make it nonempty to allow for comparisons
    end
    novaridx = find(stemhts==0);
  else
    constidx = NaN;
    stemhts = double(any(h));
    novaridx = [];
  end
  varidx = find(stemhts ~= 0);
  if isempty(varidx)
    varidx = NaN;
  end
  if any(~isreal(h(1,novaridx)))
    warning('Imaginary parts of complex constant terms ignored.');
  end

  if printflag  % reduce stem heights for printout
    stemhts = stemhts * .8;
  end
  
  if ~isempty(novaridx) % place const-height lollipops at const-only times
    stemhts(novaridx) = stemhts(novaridx) + real(h(1,novaridx));
  end
  
  stemhts = full(stemhts);
  % fixes a weird bug with stem plotting sparse stuff
  
  if colorflag    % if color labels -- draw plot
    figure(gcf); clf; hold on;
    for qq = 1:length(stemhts)
      style = '';
      if ~isreal(h(:,qq))
	style = [style 'p'];
      end
      if any(varidx == qq) & any(constidx == qq)
	% mix of const and variable
	style = [style 'r'];
      elseif any(varidx == qq)
	% variable only
	style = [style 'b'];
      elseif any(constidx == qq)
	% const only
	if printflag
	  style = [style 'k'];
	else
	  style = [style 'g'];
	end
      else
	;    
      end
      stemhand = stem(seq.locs(qq), stemhts(qq), style, 'filled');
      if ~isempty(linewidth)
	set(stemhand(2), 'LineWidth', linewidth); 
	set(stemhand(1), 'LineWidth', linewidth);
      end
      if ~isempty(markersize)
	set(stemhand(1), 'MarkerSize', markersize);
      end
    end
    hold off;
  else % no color (or pentagrams), use faster version
    stemhand = stem(seq.locs, stemhts, 'filled' ); % draw plot
    if ~isempty(linewidth)
      set(stemhand(2), 'LineWidth', linewidth);   
      set(stemhand(1), 'LineWidth', linewidth);
    end
    if ~isempty(markersize)
      set(stemhand(1), 'MarkerSize', markersize);
    end
  end
  lims = [min(seq.locs) - 0.25*abs(min(seq.locs)) ...
	  max(seq.locs) + 0.25*abs(max(seq.locs)) ...
	  min([0 min(real(h(1,novaridx)))+0.25*min(real(h(1,novaridx))) ]) ...
	  max([3 max(real(h(1,novaridx)))+0.25*max(real(h(1,novaridx))) ])];
  if lims(1) == lims(2)
    lims(1) = lims(1) - .5;
    lims(2) = lims(2) + .5;
  end
  if islinear(seq)        % if no constant terms, don't bother with y axis
    set(gca,'ytick', []);       
  end
  axis(lims)    
 
  if labelflag
    % assemble labels for the lollipops
    numfmt = '%0.2f'; labelgap = (lims(4)-lims(3))*.09;
    for qq=1:length(seq.locs)
      varlabel = makelabel(seq, numfmt, printflag, qq); 
      % call pvt function to generate label
      if(stemhts(qq)<0) % leave some space for the tags to be printed
	valgn = 'top';
	yloc = stemhts(qq) - labelgap;
      else
	valgn = 'bottom';
	yloc = stemhts(qq) + labelgap;
	if staggerflag
	  if floor(qq/2) == qq/2 % even index
	    yloc = yloc + labelgap;
	    if printflag
	      yloc = yloc + 1.5*labelgap;
	    end
	  end
	end
      end
      % print the tags
      xhand = text(seq.locs(qq),yloc,varlabel, ...
		   'HorizontalAlignment','center', ...
		   'VerticalAlignment',valgn);
      if ~isempty(fontsize)
	set(xhand, 'FontSize', fontsize);
      end
    end
  end
  
end

%title(''); xlabel('');
