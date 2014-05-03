function wbP(soln)
global h fs M th u NfH Nth N c dsub deg MHz Hand themovie frame;

hopt=[];
for k=1:N+1
  hopt(k,:)=double(optimal(h{k},soln));
end;

[Hopt,fH]=TDLfreqM2(hopt,2*NfH,1/fs,-M/fs,1000*MHz,NfH);
A=repmat(Hopt(1,:),Nth,1);
for n=1:N
  A=A+2*real(repmat(Hopt(n+1,:),Nth,1).*exp(-j*2*pi/c*n*dsub*u'*fH));
end;
delete(Hand);
%Hand=surface(th/deg,fH/MHz,dB(A'));
%shading interp;
Hand=imagesc(th/deg,fH/MHz,dB(A'));
set(gca,'YDir','normal');
drawnow;

%frame=frame+1;
%themovie(:,frame) = getframe(gca);
