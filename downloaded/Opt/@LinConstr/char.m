function c=char(lconstr) 
% LinConstr/char  converts class LinConstr to character for output
% c=char(lconstr)

tc{1}=['.rel = ' lconstr.rel];
tc{2}=' ';
tc{3}=['.vect = '];
tc{4}=char(lconstr.vect); 
c=char(tc);
