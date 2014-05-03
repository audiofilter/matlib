function B=TDLbeam(b,f,Ts)
% B=TDLbeam(b,f,Ts)
% calculates TDL sum of narrowband "beams" (element sequences)
% result is a cell array of 1 equivalent narrowband beam per frequency
% b is cell array of beams (optSequence of element weights)
% f is a vector of frequencies (in Hz)
% Ts is the tap spacing (in seconds)

B={};
for k=1:length(f)
  B{k}=b{1};
  for n=1:length(b)-1
    B{k}=B{k}+b{n+1}*exp(-j*2*pi*n*Ts*f(k))+b{n+1}'*exp(j*2*pi*n*Ts*f(k));
  end;
end;
