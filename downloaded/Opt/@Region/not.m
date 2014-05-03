function [reg] = not(a)
% REGION/NOT  complement of region
% [reg] = not(a)
%
% [reg] = not(a) is called for the syntax '~a' when a is a Region. 
%
% Note that not(a) creates one or more new Region objects in the global
% OPT_DATA structure. Therefore consider assigning na = ~a, and
% using the variable na rather than repeating ~a many times.

global OPT_DATA;

regdata = OPT_DATA.regions(a.ind);

if strcmp(regdata.type, 'composite')
  % if a is composite, recursively apply de Morgan's law to the
  % component Regions
  % i.e  (A -U- B)' = A' -I- B'
  %      (A -I- B)' = A' -U- B'
  switch regdata.oper
   case 'union'
    reg = intersect( not(Region(regdata.op1)), ...
		     not(Region(regdata.op2)) );
   case 'intersect'
    reg = union( not(Region(regdata.op1)), ...
		 not(Region(regdata.op2)) );
  end
else
  reg = Region(regdata.type, regdata.param, regdata.op1, regdata.op2, ...
	     regdata.oper);
  OPT_DATA.regions(reg.ind).complement = not(regdata.complement);
end
