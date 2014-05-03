function c=char(quadvec) 
% optQuadVector/char  converts class optQuadVector to character for output
% c=char(seq)

global OPT_DATA;

if OPT_DATA.casebug
  tc{1}=char(quadvec.optvector);   
else;
  tc{1}=char(quadvec.optVector); 
end;
tc{2}=' ';
tc{3}=['.absflag = ' num2str(quadvec.absflag)]; 
tc{4}=' ';
tc{5}=['.sqflag = ' num2str(quadvec.sqflag)]; 
c=char(tc);
