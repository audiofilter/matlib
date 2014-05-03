%$Id: vang.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
function y = vang(pid)
if ((real(pid)>0.)&(imag(pid)>0.)) 
	pid1 = pid;
elseif((real(pid)>0.)&(imag(pid)<0.))
	pid1 = -imag(pid) + i*real(pid); 
elseif((real(pid)<0.)&(imag(pid)>0.)) 
	pid1 = imag(pid) - i*real(pid);
else 
	pid1 = -pid;
end                       
y = 4.0*angle(pid1);
while (abs(y) > 2*pi) 
  if (y>0) 
    y = y - 2*pi;
  else 
    y = y + 2*pi;
  end
end
if (y<0.) 
  y = y + 2*pi;
end    