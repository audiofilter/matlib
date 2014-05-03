%$Id: qam_ber.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
%	Theory BER M-QAM, sqrt(M) is an integer (square constellation only)

%	Leo Montreuil, Nov. 94

M = input('Enter nb. of QAM points in square constellation :');
if sqrt(M)-round(sqrt(M)),
  error('Must be square constellation');
end
EndB = input('Enter vector in dB where to evaluate the error rate :');
case1 = input('Evaluate the error rate vs Eb/No or Es/No <0,1> :');
case2 = input('Evaluate the BER or SER <0,1> :');

En = 10 .^ (EndB/10);
Nbps = log(M)/log(2);

if case1,
  x = erfc(sqrt( En*3 / (2*(M-1)) ) );
  else
  x = erfc(sqrt( En*Nbps*3 / (2*(M-1)) ) );
end
pe = 2*(sqrt(M)-1)/sqrt(M).*x - 2*(M-2*sqrt(M)+1)/M.*(x.^2);
 if ~case2,
  pe = 1 - (1 - pe).^(1/Nbps);
end

semilogy(EndB,pe); grid;	% plot the BER
orient tall;
if case1,
  xlabel('Es/No (dB)');
  if ~case2,
    ylabel('BER');
    title(sprintf...
	 ('%4i QAM Bit Error Rate vs Signal Energy to Noise Ratio',M));
    else
    ylabel('SER');
    title(sprintf...
	 ('%4i QAM Symbol Error Rate vs Signal Energy to Noise Ratio',M));
  end
  else
  xlabel('Eb/No (dB)');
  if case2,
    ylabel('SER');
    title(sprintf...
	 ('%4i QAM Symbol Error Rate vs Energy per Bit to Noise Ratio',M));
    else
    ylabel('BER');
    title(sprintf...
	 ('%4i QAM Bit Error Rate vs Energy per Bit to Noise Ratio',M));
  end
end
