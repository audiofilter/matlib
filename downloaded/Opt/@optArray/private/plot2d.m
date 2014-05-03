function plot2d(seq,colorflag,labelflag,printflag,fontsize,linewidth, ...
		markersize) 

if size(seq.locs, 2) ~= 2
  error('Can only plot 2-D arrays.');
end

h = get_h(seq);
if isconst(seq)         % if it's constant, just plot heights, no labels
  if any(~isreal(h))
    %error ('Cannot plot complex sequences.')
    warning('Imaginary parts of complex terms ignored.');
  end
  if colorflag    % if color coding is desired
    if printflag
      style = 'k';
    else
      style = 'g';
    end
  else
    style = '';
  end
  stemhand = stem3(seq.locs(:,1), seq.locs(:,2), real(full(h')), ...
		   style, 'filled');
  if ~isempty(linewidth)
    set(stemhand(1),'LineWidth',linewidth); % stems
    set(stemhand(2),'LineWidth',linewidth); % heads
    % note: stem3 handles are the opposite of stem
  end
  if ~isempty(markersize)
    set(stemhand(2), 'MarkerSize', markersize);
  end
  zlims = get(gca, 'ZLim');
  zlims(1) = zlims(1) - 0.25*abs(zlims(1));
  zlims(2) = zlims(2) - 0.25*abs(zlims(2));
  lims = [min(seq.locs(:,1))-1 max(seq.locs(:,1))+1 ...
	  min(seq.locs(:,2))-1 max(seq.locs(:,2))+1 ...
	  zlims];
  %min([0 min(h)+0.25*min(h)]) max(h)+0.25*max(h)]; 
  axis(lims)
  if labelflag   % if text labels are desired
    for qq=1:size(seq.locs,1)
      varlabel = [num2str(h(1,qq))];
      if(h(1,qq)<0) % leave some space for the tags to be printed
	valgn = 'top';
	varlabel = [{' '}; {varlabel}];
      else
	valgn = 'bottom';
	varlabel = [{varlabel}; {' '}];
      end
      % print the tags
      xhand = text(seq.locs(qq,1),seq.locs(qq,2),h(1,qq),varlabel, ...
		   'HorizontalAlignment','center', ...
		   'VerticalAlignment',valgn);
      if ~isempty(fontsize)
	set(xhand, 'FontSize', fontsize);
      end
    end
  end
  xlabel('x'); ylabel('y');
  
else
  xoff = get_xoff(seq);
  
  % place height-1 lollipops at time locations dependent on vars    
  if xoff == -1
    stemhts = any(h(2:end,:));
    constidx = find(h(1,:));
    if isempty(constidx)
      constidx = NaN; % make it nonempty to allow for comparisons
    end
  else
    constidx = NaN;
    stemhts = any(h);
  end
  novaridx = find(stemhts == 0);
  varidx = find(stemhts ~= 0);
  if isempty(varidx)
    varidx = NaN;
  end
  if any(~isreal(h(1,novaridx)))
    warning('Imaginary part of complex constant terms ignored.');
  end
  stemhts = double(stemhts); 
  % required for MATLAB 13, since stemhts was a LOGICAL array
  if ~isempty(novaridx) % place const-height lollipops at const-only times
    stemhts(novaridx) = stemhts(novaridx) + real(h(1,novaridx));
  end
  % draw plot
  figure(gcf); clf; grid on; hold on;
  if colorflag % if color (and pentagrams desired)
    for qq = 1:length(stemhts)
      style = '';
      if ~isreal(h(:,qq))
	style = [style 'p'];
      end
      if any(varidx == qq) & any(constidx == qq)
	style = [style 'r'];
      elseif any(varidx == qq)
	style = [style 'b'];
      elseif any(constidx == qq)
	if printflag
	  style = [style 'k'];
	else
	  style = [style 'g'];
	end
      else
	;    
      end
      stemhand = stem3(seq.locs(qq,1), seq.locs(qq,2), stemhts(qq), ...
		       style, 'filled');
      if ~isempty(linewidth)
	set(stemhand(1), 'LineWidth', linewidth);
	set(stemhand(2), 'LineWidth', linewidth);
      end
      if ~isempty(markersize)
	set(stemhand(2), 'MarkerSize', markersize);
      end
    end
  else % quicker version; no color or pentagrams
    stemhand = stem3(seq.locs(:,1), seq.locs(:,2), full(stemhts'), ...
		     'filled');
    if ~isempty(linewidth)
      set(stemhand(1), 'LineWidth', linewidth);
      set(stemhand(2), 'LineWidth', linewidth);
    end
    if ~isempty(markersize)
      set(stemhand(2), 'MarkerSize', markersize);
    end
  end
  hold off;
  lims = [min(seq.locs(:,1))-1 ...
	  max(seq.locs(:,1))+1 ...
	  min(seq.locs(:,2))-1 ...
	  max(seq.locs(:,2))+1 ...            
	  min([0 min(real(h(1,novaridx)))+0.25*min(real(h(1,novaridx))) ]) ...
	  max([3 max(real(h(1,novaridx)))+0.25*max(real(h(1,novaridx))) ])];
  if islinear(seq)        % if no constant terms, don't bother with z axis
    set(gca,'ztick', []);       
  end
  axis(lims)
  xlabel('x'); ylabel('y');
  
  if labelflag    
    % if labels are desired
    % assemble labels for the lollipops
    for qq=1:size(seq.locs,1)
      numfmt = '%5.2f';
      varlabel = makelabel(seq, numfmt, printflag, qq);
      if(stemhts(qq)<0) % leave some space for the tags to be printed
	valgn = 'top';
	varlabel = [{' '}; {varlabel}];
      else
	valgn = 'bottom';
	varlabel = [{varlabel}; {' '}];
      end
      % print the tags
      xhand = text(seq.locs(qq,1),seq.locs(qq,2),stemhts(qq),varlabel, ...
		   'HorizontalAlignment','center', ...
		   'VerticalAlignment',valgn);
      if ~isempty(fontsize)
	set(xhand, 'FontSize', fontsize);
      end
    end
  end
  
end
