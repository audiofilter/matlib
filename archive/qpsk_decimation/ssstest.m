function sss = ssstest(over,stages)
% Sharpened CIC (Cascaded integrated comb) filter using
% Kaiser Method (3-2*x)*x*x
imp = [1];
for ii=1:2*stages
  imp = conv(imp,ones(1,over))/over;
end
cic_sub = imp;
for ii=2*stages+1:3*stages
  imp = conv(imp,ones(1,over))/over;
end
cic_main = -2*imp;
cic_sub = [zeros(1,over-1) 3*cic_sub zeros(1,over-1)];
sss = cic_sub + cic_main;

