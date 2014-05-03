function c=char(lat) 
% LATTICE/CHAR  converts class LATTICE to character for output
% c=char(lat)

tc{1}=['.M = '];
tc{2}=num2str(lat.M,'%8.2f'); 
tc{3}=' ';
tc{4}=['.scale = ' num2str(lat.scale)]; 
tc{5}=' ';
tc{6}=['.off = ' num2str(lat.off)];

c=char(tc);
