function c=char(seq) 
% OPTSEQUENCE/CHAR  converts class optSequence to character for output
% c=char(seq)

global OPT_DATA;

if OPT_DATA.casebug
   tc{1}=char(seq.optvector); 
else
   tc{1}=char(seq.optVector); 
end;
tc{2}=' ';
tc{3}=['.noff = ' num2str(seq.noff)]; 
c=char(tc);
