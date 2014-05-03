function hand=plot(rp,f, varargin)
% PROCESS/PLOT  Plot random process
% [hand]=plot(rp)
% Graphically displays the power spectra of the base
% processes making up rp.
% Returns the plot handle.
%
% plot(rp, f) plots the process rp at the frequencies given in f.
%
% plot(rp, [], 'o') plots the process and overlays plots of the
% individual base processes, choosing the frequencies
% automatically.
%
% plot(rp, f, 'o') is the same as above, but at the frequencies
% given in f.

global OPT_DATA;
hand = [];

% defaults
overlayopt = logical(0);
printflag = logical(0);

qq=1;
while qq<=length(varargin)
  if ischar(varargin{qq})
    switch lower(varargin{qq})
     case {'o', 'overlay'}
      overlayopt = logical(1);
     case 'nooverlay'
      overlayopt = logical(0);
     case {'p', 'print'}
      printflag = logical(1);
     case 'noprint'
      printflag = logical(0);
     otherwise
      error('unknown option to plot');
    end
  else
    error('options must be strings');
  end
  qq = qq+1;
end

if (nargin==1) | isempty(f)
  Nf=1000; f=(0:Nf-1)/Nf;
else
  Nf=length(f);
end;    
M=length(rp.ind);
for m=1:M
  basis=OPT_DATA.procs(rp.ind(m)).basis;
  Coeff=OPT_DATA.procs(rp.ind(m)).Coeff;
  offset=OPT_DATA.procs(rp.ind(m)).offset;
  Nc=length(Coeff);
  S=zeros(1,Nf);
  subplot(M,1,m);
  cla;
  for n=1:Nc
    if overlayopt
      hold on;
      if printflag
	thand = plot(f, Coeff(n)*...
		     feval([basis 'Freq'], ...
			   mod(f*Nc-n+1-offset+Nc/2,Nc)-Nc/2,0), ...
		     'r', 'LineWidth', .3);
      else
	thand = plot(f, Coeff(n)*...
		     feval([basis 'Freq'], ...
			   mod(f*Nc-n+1-offset+Nc/2,Nc)-Nc/2,0), ...
		     'r:');
      end
      hand = [hand; thand];
      hold off;
    end
    S=S+Coeff(n)*feval([basis 'Freq'],mod(f*Nc-n+1-offset+Nc/2,Nc)-Nc/2,0);
    % need this mess to cover multiple periods
    %S=S+Coeff(n)*feval([basis 'Freq'],mod(f,1)*Nc-n+1,mod(offset,Nc));
  end;    
  
  if overlayopt
    hold on;
    if printflag
      thand = plot(f, S, 'LineWidth', 1.35);
    else
      thand = plot(f,S);
    end
    hold off;
  else
    if printflag
      thand = plot(f, S, 'LineWidth', 1.35);
    else
      thand = plot(f,S);
    end
  end
  hand = [hand; thand];
  axis([f(1) f(end) min(S)-.1*(max(S)-min(S)) max(S)+.1*(max(S)-min(S))])
end;
