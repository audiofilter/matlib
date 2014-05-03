function c=char(rp) 
% PROCESS/CHAR  converts class Process to character for output
% c=char(rp)

global OPT_DATA;
for n=1:length(rp.ind)
  tc{6*(n-1)+1}=['basis = ' OPT_DATA.procs(rp.ind(n)).basis];
  tc{6*(n-1)+2}=['offset = ' num2str(OPT_DATA.procs(rp.ind(n)).offset)]; 
  tc{6*(n-1)+3}=['Coeff = ' num2str(OPT_DATA.procs(rp.ind(n)).Coeff)]; 
  tc{6*(n-1)+4}=['sys = '];
  tc{6*(n-1)+5}=char(rp.sys{n}); 
  tc{6*(n-1)+6}=' ';
end;
c=char(tc);
