global f Nf h handle;

InitOpt;
ov=newOptSpace;
N=15;
a=optSequence(N,ov);
b=optSequence(N,ov);
z=a+j*b;
c=optSequence(1,ov);
h=(z|1)'+c+(z|1);

dnu=1/(100*N);                      % L1 requires tighter grid than Linf?
nu_pb=0.2:dnu:.45;                 % passband grid
nu_sb=[0:dnu:.1 .55:dnu:1];        % stopband grid
delta=optVector(length(nu_sb),ov);   % aux variables for stopband L1
Hpb=fourier(h,nu_pb);              % passband freq. resp. 
Hsb=fourier(h,nu_sb);              % stopband freq. resp.
 % constraints: equiripple passband, L1 stopband
constr={10^(-.01/20)<Hpb Hpb<10^(.01/20) -delta<Hsb Hsb<delta};

%soln0=minimize(sum(delta),constr,ov,'loqo');    % loqo LP
%soln0=minimize(sum(delta),constr,ov,'boydsocp');    % boyd LP
%soln0=minimize(sum(delta),constr,ov,'sdppack');    % sdppack LP
soln0=minimize(sum(delta),constr,ov,'sedumi');    % sedumi LP
%soln0=minimize(sum(delta),constr,ov,'mosekdual');    % sedumi LP
Nf=4000; f=(0:Nf-1)/Nf;
%hold on; handle=plot(0); axis([0 1 -80 5]);
%soln0=minimize(sum(delta),constr,ov,'loqosoclp','testPlot');    % 

hopt0=full(get_h(optimal(h,soln0)));
H0=fft(hopt0,Nf);
plot(f,20*log10(abs([H0])));
axis([0 1 -150 5]);
grid;
%legend('loqo1','loqo2',0);
