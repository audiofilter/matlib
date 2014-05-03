function plot3d(seq,colorflag,labelflag,printflag,fontsize, ...
		linewidth,markersize) 
% OPTARRAY/PLOT3D Graphical representation of 3-D optArray


if size(seq.locs, 2) ~= 3
  error('Can only plot 3-D arrays.');
end

h = get_h(seq);
xoff = get_xoff(seq);

% draw plot
figure(gcf); clf; grid on; hold on;
if colorflag    % if color labels desired
  for qq = 1:size(h,2)
    if ~isreal(h(:,qq)) % for complex, use a pentagram
      style = 'p';
    else    % for purely real, use a circle
      style = 'o';
    end

    if islinear(seq)
      style = [style 'b'];
    elseif isconst(seq)
      style = [style 'g'];
    else % it's affine
      if any(h(2:end,qq)) & h(1,qq) ~= 0
	style = [style 'r'];
      elseif any(h(2:end,qq))
	style = [style 'b'];
      elseif h(1,qq) ~= 0
	style = [style 'g'];
      else
	error('how''d that happen?');
      end
    end
    phand = plot3(seq.locs(qq,1), seq.locs(qq,2), seq.locs(qq,3), ...
		  style);
    if ~isempty(markersize)
      set(phand, 'MarkerSize', markersize);
    end
  end
else
  phand = plot3(seq.locs(:,1), seq.locs(:,2), seq.locs(:,3),'o');
  if ~isempty(markersize)
    set(phand, 'MarkerSize', markersize);
  end
end
hold off;
lims = [min(seq.locs(:,1))-1 ...
        max(seq.locs(:,1))+1 ...
        min(seq.locs(:,2))-1 ...
        max(seq.locs(:,2))+1 ... 
        min(seq.locs(:,3))-1 ...
        max(seq.locs(:,3))+1 ];
axis(lims)
xlabel('x'); ylabel('y'); zlabel('z');

if labelflag    % if labels are desired
  % assemble labels for the lollipops
  for qq=1:size(seq.locs,1)
    numfmt = '%5.2f';
    varlabel = makelabel(seq, numfmt, printflag, qq);
    
    varlabel = [{varlabel}; {' '}];
    % print the tags
    xhand = text(seq.locs(qq,1),seq.locs(qq,2),seq.locs(qq,3),varlabel, ...
		 'HorizontalAlignment','center', ...
		 'VerticalAlignment', 'bottom');
    if ~isempty(fontsize)
      set(xhand, 'FontSize', fontsize);
    end	
  end
end


