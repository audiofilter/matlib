function c=char(seq) 
% OPTARRAY/CHAR  converts class optArray to character for output
% c=char(seq)

global OPT_DATA;

if OPT_DATA.casebug
   tc{1}=char(seq.optvector); 
else
   tc{1}=char(seq.optVector); 
end;
tc{2}=' ';
tc{3}=['.locs = ' ];
tc{4}=num2str(seq.locs); 
c=char(tc);
