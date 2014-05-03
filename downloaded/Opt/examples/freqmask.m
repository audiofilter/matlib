InitOpt;
ovh=newOptSpace;

%number of groups of four samples in h on each side of center:
%N=4;
N=10;

%a real, linear-phase, fifth-band filter h from its five polyphase components:
h0=optSequence([.2]);
h1=((optSequence(2*N,ovh)|(-N))./5)|1;
h2=((optSequence(2*N,ovh)|(-N))./5)|2;
h3=h2';
h4=h1';
h=h0+h1+h2+h3+h4;

x=Process('Box',0.5,[zeros(1,115),ones(1,770),zeros(1,115)]);
mse=pwr(x.*h)/pwr(x);

rms=optVar(ovh);
solnh=minimize(rms,{mse<rms.^2},ovh,'loqosoclp');

%hopt=double(optimal(h,solnh));
%plot(dB(fft(hopt,1000)));

L=3;
hopt0=h0;
hopt1=optimal(h1,solnh);
hopt2=optimal(h2,solnh);
hopt3=optimal(h3,solnh);
hopt4=optimal(h4,solnh);

ovg=newOptSpace;

%one-side length of masking filters
%M=3;
M=7;

%turns out that g1=g4' and g3=g2', a kind of linear-phase requirement:

g0=(optSequence(2*M+1,ovg))|(-M);
g1=(optSequence(2*M+1,ovg))|(-M);
g2=(optSequence(2*M+1,ovg))|(-M);
g3=(optSequence(2*M+1,ovg))|(-M);
g4=(optSequence(2*M+1,ovg))|(-M);

g=g0.*hopt0+g1.*(hopt1./L)+g2.*(hopt2./L)+g3.*(hopt3./L)+g4.*(hopt4./L);

x=Process('Box',0.5,[zeros(1,240),ones(1,520),zeros(1,240)]);
%this is slow
mses=pwr(x.*g)/pwr(x);

y=Process('Box',0.5,[ones(1,225),zeros(1,550),ones(1,225)]);
%this is also
msep=pwr(y.*g-y)/pwr(y);

nsamphalf=floor((length(g)-1)/2/15);
z0=[-nsamphalf:-1,1:nsamphalf]*15;

b=optVector(length(z0),ovg);
rms=optVar(ovg);

constraints={sum(g)==1,-b<g(z0),g(z0)<b,1000*sum(b)<7/15,g(0)==7/15,mses<10^(-6),msep<rms.^2};
solng=minimize(rms,constraints,ovg,'sedumi');

gopt=double(optimal(g,solng));
plot(dB(fft(gopt,1000)));

