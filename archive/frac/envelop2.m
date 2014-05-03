function V = envelop2(vec);
% ENVELOP2
% MATLAB m-file for determining the envelope curve 
% of the argument vector
% format: V = envelop2(vec)
% Timo Laakso   24.07.1992
% Last revision 16.01.1996
%
vec=abs(vec); NV=length(vec);
env=zeros(1,NV); env(1)=vec(1); env(NV)=vec(NV);
oldif=vec(2)-vec(1);
%
for i=2:NV            % find local maxima
  dif=vec(i)-vec(i-1);
  if ((dif<0)&(oldif>=0)) env(i-1)=vec(i-1); end
  oldif=dif;
end;
oldi=1;
for i=2:NV        % construct continuous broken line
  if (env(i)>0)
    dist=i-oldi;
    delta=(env(i)-env(oldi))/dist;
    for k=1:dist
      env(oldi+k)=env(oldi)+k*delta;
    end
    oldi=i;
  end
end
env=max(env,vec);
%x=1:NV;
%plot(x,vec,'--r',x,env,'-g'); grid; title('ENVELOPE');
V=env;