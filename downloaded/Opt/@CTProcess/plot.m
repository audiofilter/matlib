function hand=plot(rp,f,varargin)
% CTPROCESS/PLOT  Plot random process
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

%clf

M=length(rp.ind);
for m=1:M
  basis=OPT_DATA.ctprocs(rp.ind(m)).basis;
  Coeff=OPT_DATA.ctprocs(rp.ind(m)).Coeff;
  scale=OPT_DATA.ctprocs(rp.ind(m)).scale;
  freqs=OPT_DATA.ctprocs(rp.ind(m)).freqs;
  Nc=length(Coeff);
  
  % determine good frequency range and step size
  if Nc == 1
    fstep = scale/1000;
  else
    fstep = (freqs(end)-freqs(1)+2*scale)/1000;
  end;
  if (nargin==1) | isempty(f)
    f = (freqs(1)-scale):fstep:(freqs(end)+scale);
  else
    ;
  end
  
  S=zeros(1,length(f));
  subplot(M,1,m);
  cla;
  for n=1:Nc
    if overlayopt
      hold on;
      thand = plot(f, Coeff(n)*feval([basis 'Freq'],f,scale,freqs(n)), ...
		   'r:');
      hand = [hand; thand];
      hold off;
    end
    S=S+Coeff(n)*feval([basis 'Freq'],f,scale,freqs(n));
  end;    

  if overlayopt
    hold on;
    thand = plot(f,S);
    hold off;
  else
    thand = plot(f,S);
  end
  hand = [hand; thand];
  
  % determine good axis ranges
  if max(S) == min(S)
    % for constant spectrum
    lims = [f(1) f(end) 0 1.1*max(S)];
  else
    lims = [f(1) f(end) ...
	    min(S)-.1*(max(S)-min(S)) max(S)+.1*(max(S)-min(S))];
  end
  axis(lims)
  title('PSD of random process'); xlabel('Frequency (Hz)');
end;

if nargout == 0
  clear hand
end
