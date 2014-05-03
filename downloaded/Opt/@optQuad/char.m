function c=char(quad) 
% OPTQUAD/CHAR  converts class optQuad to character for output
% c=char(quad)

tc{1}=['.kernel = '];
tc{2}=num2str(quad.kernel,'%8.2f'); 
tc{3}=' ';
tc{4}=['.factored = ' num2str(quad.factored)]; 
tc{5}=' ';
tc{6}=['.xoff = ' num2str(quad.xoff)]; 
tc{7}=' ';
tc{8}=['.pool = ' num2str(double(quad.pool))]; 
c=char(tc);
