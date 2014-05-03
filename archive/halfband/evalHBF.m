function HBF = evalHBF(f1,f2,w)
%function HBF = evalHBF(f1,f2,w)	Evaluate a Saramaki HBF at frequency w

F2 = zeros(size(w));
for i = 1:length(f2)
    F2 = F2 + f2(i)*cos(w*(2*i-1));
end
F2 = F2*2;

HBF = f1(1);
for i = 2:length(f1)
    HBF = HBF + f1(i)*F2.^(2*i-3);
end
