function In = ElementOf(Number,Vector)
% checks to see if Number is an element of Vector

In=0;
L=Vector(Vector==Number);
if length(L)>0,
  In=1;
end;
return
