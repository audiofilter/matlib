function G=fourier(g,f)
% OPTARRAY/FOURIER  sequence Fourier transform
% G=fourier(g,f)
% returns FT of optArray g at f as an optArray
% where f = [ f_1 | f_2 | ... | f_n ]
% with n of the same dimension as g 

global OPT_DATA;

if ~isa(g,'optArray')
    error('check order of arguments to OPTARRAY/FOURIER.')
end

if size(f,2) ~= size(g.locs,2)
    error(['freq vector is ', num2str(size(f,2)), '-D while optArray is ', ...
            num2str(size(g.locs,2)), '-D.']);
end

h=get_h(g);

if exist('fourierEngine') ~= 3
  warning(['MEX file not present. Matlab routine used instead.'])
end

if (OPT_DATA.mexflag == 1) & (exist('fourierEngine') == 3)
  Gh = fourierEngine(h, g.locs, f);
else
  freq_time_prod=1e6; % product of size of freq segment and time length
  Nt=length(g);  % number of time positions
  Nf=size(f,1);  % number of frequencies
  segsize=ceil(freq_time_prod/Nt);     % segment length
  numsegs=floor(Nf/segsize);

  Gh = zeros(size(h,1),size(f,1));
  for k=0:numsegs-1
    Gh(:,k*segsize+(1:segsize)) = ...
	h * exp(-j*2*pi*g.locs*f(k*segsize+(1:segsize),:)');
  end;
  if numsegs*segsize<Nf
    Gh(:,segsize*numsegs+1:Nf) = ...
	h * exp(-j*2*pi*g.locs*f(segsize*numsegs+1:Nf,:)');
  end;
end


G=optArray;
G=set_h(G,Gh);
G=set_xoff(G,get_xoff(g));
G=set_pool(G,get_pool(g));
G.locs = f;
