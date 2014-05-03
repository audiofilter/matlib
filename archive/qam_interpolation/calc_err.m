symcount = 0;
sq_err = 0;
rcv_data = 0;
ierr = 0;
qerr = 0;
mean_ang = 0+0*j;
i_data = conv(nrcv,orig_rcf);
vx = 0+i*0;
phase_off = 0.0;

for mm = 200+sample_offset: 4: size(rcv,2)
  symcount = symcount+1;
  rcv_data = i_data(mm);
  scat(symcount) = rcv_data;
  vang4 = vang(rcv_data);
  vx = vx + exp(i*vang4);
end
oang = angle(vx/symcount)/4 - pi/4;
if (oang < -pi/4)
  oang = oang + pi/2;
end
%oang = oang*180/pi;

symcount = 0;
sq_err = 0;
rcv_data = 0;
ierr = 0;
qerr = 0;
phase_off = -oang;

for mm = 200+sample_offset: 4: size(rcv,2)
  symcount = symcount+1;
  rcv_data = i_data(mm)*exp(i*phase_off);
  if (real(rcv_data) > 0)
    ierr = real(rcv_data) - 1;
  else
    ierr = real(rcv_data) + 1;
  end
  sq_err = sq_err + ierr*ierr;
  if (imag(rcv_data) > 0)
    qerr = imag(rcv_data) - 1;
  else
    qerr = imag(rcv_data) + 1;
  end
  sq_err = sq_err + qerr*qerr;
  scat(symcount) = rcv_data;
end
rms_err = sqrt(sq_err/symcount);
mean_ang = angle(mean_ang/symcount)-pi/4;
%disp('snr = ');  disp(-20*log10(rms_err));
%plot(real(scat),imag(scat),'*');


