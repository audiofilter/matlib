% Test routine for BPE 
% PN Generators for I & Q
clear all;
preamble = 32;
np=1300;
yi = [pngen1(preamble,[2,5],[1 zeros(1,4)]) pngen1(np-preamble,[1,6,8,14],[1 zeros(1,13)])];
yq = [pngen1(preamble,[1,2,4,5],[1 zeros(1,4)]) pngen1(np-preamble,[1,6,10,14],[1 zeros(1,13)])];

r = zeros(1,np) + i*zeros(1,np);

% Random initial phase;
init_phase = 0.6;
%init_phase = rand*2*pi;
ph_deg = init_phase*180/pi;

freq = 0.005
for j=1:np;
	r(j) = (yi(j) + i*yq(j))*exp(i*(init_phase+freq*j));
%	r(j) = exp(i*(init_phase+freq*j));
end
plot(real(r),imag(r),'.');

RTD = 57.295781;
nbpe = 8;
oqtstate = 0; 
quad_prev = 0;
bit = zeros(1,nbpe) + i*zeros(1,nbpe);				

% Equalizer filter data and weights initial conditions
mms = 0;
for j=1:np-3;
	in = r(j);
	bpe;
	angout(j) = 180*ang/pi;
	qp(j) = quad_now;
% End BPE
% Apply BPE phase correction

end
% Plot signals
figure;
plot(angout);


