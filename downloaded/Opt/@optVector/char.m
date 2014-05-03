function c=char(opt) 
% OPTVECTOR/CHAR  converts class optVector to character for output
% c=char(opt)

tc{1}=['.h = '];
if size(opt.h,2)<50 & size(opt.h,1)<50
  tc{2}=num2str(opt.h,'%8.2f'); 
else
  tc{2} = ['   [' num2str(size(opt.h,1)) 'x' ...
	   num2str(size(opt.h,2)) ' matrix]'];
end
tc{3}=' ';
tc{4}=['.xoff = ' num2str(opt.xoff)]; 
tc{5}=' ';
tc{6}=['.pool = ' num2str(double(opt.pool))]; 
c=char(tc);
