function c=char(soln) 
% SOLUTION/CHAR  converts class Solution to character for output
% c=char(soln)

tc{1}=['.x = '];
tc{2}=num2str(soln.x, '%8.2f');
tc{3}=' ';
tc{4}=['.y = ' ];
tc{5}=num2str(soln.y, '%8.2f'); 
tc{6}=' ';
tc{7}=['.pool = '];
tc{8}=char(soln.pool);
c=char(tc);
