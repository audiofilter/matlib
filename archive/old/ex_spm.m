% Inputs
% NP 
% a
% a1
% a2
% mfir
% nv
% fir
% freq

% Demonstration of DFE Equalizer Using PN code
% generator for data (7-Apr-94).

over = 4;
yz = zeros(1,over*np) + i*zeros(1,over*np);
rz = yz;
y = zeros(1,np) + i*zeros(1,np);
r = y;

pn = 1;
% PN Generators for I & Q
yi = [pngen1(preamble,[2,5],[1 zeros(1,4)]) pngen1(np-preamble,[1,6,8,14],[1 zeros(1,13)])];
yq = [pngen1(preamble,[1,2,4,5],[1 zeros(1,4)]) pngen1(np-preamble,[1,6,10,14],[1 zeros(1,13)])];
%yq = [([ones(1,preamble)]) pngen1(np-preamble,[1,6,10,14],[1 zeros(1,13)])];

% Equalizer filter data and weights initial conditions
yz = zeros(1,over*np) + i*zeros(1,over*np);

% Random initial phase;
init_phase = 2.4096;
%init_phase = rand*2*pi;
ph_deg = init_phase*180/pi

if (pn==1) 
% PN Case
	for j=1:np;
		yz(over*j) = (yi(j) + i*yq(j));
	end
else
% SQ WAVE + DC Case
	init = -1;
	for j=1:preamble;
		init = -init;
		yz(over*j) = (init+i)*exp(i*init_phase);
	end
	for j=preamble+1:np;
		yz(over*j) = (yi(j) + i*yq(j));
	end
end

y = filter(mfir,1,yz);
pz = filter([1 a],1,y);
rz = filter([-a2 a1*i 1],[-1 a1*i a2],pz);
for j=1:over*np;
	rz(j) = rz(j) + nv*randn + nv*i*randn;
end

sf = sum(fir);
rr = filter(fir,1,rz);
for j=off:np-1;
	r(j-off+1) = 4*rr(j*over+off)*exp(i*(freq*(j-off)+init_phase))/sf;
end
plot(real(r),imag(r),'.');
axis('square');
clear y;
clear yz;
clear pz;
clear rz;
clear yi;
clear yq;
clear rr;
