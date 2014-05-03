function c=char(reg) 
% REGION/CHAR  converts class Region to character for output
% c=char(reg)

global OPT_DATA;

if reg.ind > length(OPT_DATA.regions)
  error('Region is no longer allocated.');
end

param = OPT_DATA.regions(reg.ind).param;

tc{1}=['.ind = ' num2str(reg.ind)]; 
tc{2}=['type = ' OPT_DATA.regions(reg.ind).type ', ' ...
      num2str(param.dim) '-D'];
tc{3}=' ';

flds = fieldnames(param);
tc{4}=['parameters:'];
%tc{6}= char(flds);
lnum = 4;
for qq=1:length(flds)
  curfield = getfield(param, flds{qq});
  if size( curfield, 1) == 1
    tc{lnum+qq} = ['   ' flds{qq} ' = ' num2str(curfield)]; 
  else
    tc{lnum+qq} = ['   ' flds{qq} ' = [' num2str(size(curfield,1)) 'x' ...
		   num2str(size(curfield,2)) ' ' class(curfield) ']' ] ;
  end
end
lnum = 4+length(flds)+1;

if strcmp(OPT_DATA.regions(reg.ind).type, 'composite')
  tc{lnum}=' ';
  tc{lnum+1}=['op1 = ' num2str(OPT_DATA.regions(reg.ind).op1)];

  %tc{lnum+2}=' ';
  tc{lnum+2}=['op2 = ' num2str(OPT_DATA.regions(reg.ind).op2)];
  %tc{lnum+4}=' ';
  tc{lnum+3}=['oper = ' num2str(OPT_DATA.regions(reg.ind).oper)];
  lnum = lnum+4;
end

if OPT_DATA.regions(reg.ind).complement
  %tc{lnum+6}=' ';
  tc{lnum}='complemented';
end

c=char(tc);

