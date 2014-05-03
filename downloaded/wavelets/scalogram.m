function out = scalogram(in)

code='daub20';
N=size(in,2);
stages=log2(N);
tin=wt(in,code,stages);
tin([1:N])=tin([N:-1:1]);
acum=tin([1:N/2]);
for j=1:(stages-1) acum=[acum ;acum]; end
factor=1;
start=1; endd=N/2; inc=N/2; rep=stages-1;

for i=1:stages
  if(i~=stages) 
     factor=[factor;factor]; 
     inc=inc/2; 
     rep=rep-1;
  end
  start=1+endd; endd=endd+inc;
  a=tin([start:endd]);
  a=factor*a;
  a=a(:)';
  for j=1:rep a=[a;a]; end
  acum=[acum;a];
end


contour(acum);
out=acum;
end
  
