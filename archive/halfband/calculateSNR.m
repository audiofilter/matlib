function snr = calculateSNR(hwfft,f)
% snr = calculateSNR(hwfft,f) Estimate the signal-to-noise ratio, 
% given the in-band bins of a Hann-windowed fft and 
% the location of the input signal (f>0).
% The input tone is contained in hwfft(f:f+2);
% the SNR is expressed in dB.
s = norm(hwfft(f+1))*sqrt(8);		% /N for true rms value;
if f<4
    noiseBins = [f+3:length(hwfft)];
elseif f+3>length(hwfft)
    noiseBins = [1:f-1];
else
    noiseBins = [1:f-1 f+3:length(hwfft)];
end
n = norm(hwfft(noiseBins))*4/sqrt(3);	% /N for true rms value;
snr = dbv(s/n);
