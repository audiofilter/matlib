function c=char(rp) 
% NDPROCESS/CHAR  converts class NDProcess to character for output
% c=char(rp)

global OPT_DATA;
for n=1:length(rp.ind)
  tc{6*(n-1)+1}=[num2str(OPT_DATA.ndprocs(rp.ind(n)).dim) '-D.'];
  tc{6*(n-1)+2}=['basis = ' OPT_DATA.ndprocs(rp.ind(n)).basis];
  tc{6*(n-1)+3}=['width = '];
  tc{6*(n-1)+4}=[num2str(OPT_DATA.ndprocs(rp.ind(n)).width)]; 
  tc{6*(n-1)+5}=['freqs = '];
  tc{6*(n-1)+6}=[num2str(OPT_DATA.ndprocs(rp.ind(n)).freqs)];
  tc{6*(n-1)+7}=['Coeff = ' num2str(OPT_DATA.ndprocs(rp.ind(n)).Coeff)]; 
  tc{6*(n-1)+8}=['sys = '];
  tc{6*(n-1)+9}=char(rp.sys{n}); 
  tc{6*(n-1)+10}=' ';
end;
c=char(tc);
