function Value=Factorial(G);
%pass in INTEGER G, you get G!
% 0!=1, any neg!=0

Vector=[G:-1:1];
if length(Vector)>0,
   Value=prod(Vector);
elseif G==0,
   Value=1;
else
   Value=0;
end;
return;
