function c=char(os) 
% OPTSPACE/CHAR  converts class optSpace to character for output
% c=char(os)

tc{1}=['.spacename = ' os.spacename];
tc{2}=' ';
tc{3}=['.poolnum = ' num2str(os.poolnum)];
c=char(tc);
