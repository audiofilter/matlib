function c=char(rp) 
% CTPROCESS/CHAR  converts class CTProcess to character for output
% c=char(rp)

global OPT_DATA;
for n=1:length(rp.ind)
  tc{6*(n-1)+1}=['basis = ' OPT_DATA.ctprocs(rp.ind(n)).basis];
  tc{6*(n-1)+2}=['scale = ' num2str(OPT_DATA.ctprocs(rp.ind(n)).scale)]; 
  tc{6*(n-1)+3}=['freqs = ' num2str(OPT_DATA.ctprocs(rp.ind(n)).freqs)];
  tc{6*(n-1)+4}=['Coeff = ' num2str(OPT_DATA.ctprocs(rp.ind(n)).Coeff)]; 
  tc{6*(n-1)+5}=['sys = '];
  tc{6*(n-1)+6}=char(rp.sys{n}); 
  tc{6*(n-1)+7}=' ';
end;
c=char(tc);
