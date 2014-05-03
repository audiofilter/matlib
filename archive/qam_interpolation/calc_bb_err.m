symcount = 0;
sq_err = 0;
rcv_data = 0;
ierr = 0;
last = size(rcv,2)-256;

for mm = 200+sample_offset: 4: last
  symcount = symcount+1;
  rcv_data = nrcv(mm);
  if (real(rcv_data) > 0)
    ierr = real(rcv_data) - ref;
  else
    ierr = real(rcv_data) + ref;
  end
  sq_err = sq_err + ierr*ierr;
  scat(symcount) = rcv_data;
  dem(mm) = rcv_data;
  err((mm-196-sample_offset)/4) = ierr;
end
rms_err = sqrt(sq_err/symcount);
%disp('snr = '),  disp(-20*log10(rms_err));
%plot(real(scat),imag(scat),'*');