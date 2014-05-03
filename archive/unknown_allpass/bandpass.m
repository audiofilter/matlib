% BANDPASS ALLPASS FILTER USING EIGEN METHOD
clear
NN=600;
omega=pi/NN*(0:NN-1);
wp=input('wp=');
ws=input('ws=');
fprintf('wp= %f pi \n',wp)
fprintf('ws= %f pi \n',ws)
wp=wp*pi;
ws=ws*pi;
kp=round(wp/pi*NN);
ks=round(ws/pi*NN);
tau=input('tau=');
N=input('N=');

w(N+1:-1:1)=(ws-wp)/(N)*(0:N)+wp;
%disp('freq point is')
%disp(w/pi)

% $@=jK>0LAj(J
%thd=-tau*omega-0.5*pi;
thd=-tau*omega+pi*sin(omega);

delta=0.01;
while 1

%$@<~GH?tE@>e$N=jK>0LAj(J
  %thdi=-tau*w-0.5*pi;
  thdi=-tau*w+pi*sin(w);
  
  for i=1:N+1
    for n=1:N+1
      fai=(n-1)*w(i)-0.5*(N*w(i)+thdi(i));
      P(i,n)=sin(fai);
      Q(i,n)=(-1)^(i+1)*cos(fai);
    end
    del(i)=(-1)^(i+1);
  end
  %disp('Matrix is')
  %disp(Q\P)


  [X,D]=eig(P\Q);   		% $@8GM-CM$r5a$a$k(J
  [d,k]=sort(abs(diag(D)));       % $@8GM-CM$r%=!<%H(J
  dd=diag(D);
  dd=dd(k);
  A=X(:,k);
  disp('eigen value is')
  disp(dd')
  %disp('eigen vector is')
  %disp(A)

% $@3F8GM-CM$K$h$kFC@-(J
	figure(1)
	clf
	for ii=N+1:-1:N-2
  	  a2=A(:,ii);
          delta2=2*atan(1.0/dd(ii));
  	  a12=a2(1);
  	  a2=a2/a12;
  	  b2=flipud(a2); 
  	  %h2=freqz(b2,a2,omega);
  	  %phase2=unwrap(angle(h2));
	  phase2=phares(a2,omega,N);
  	  if ii==N+1  
    	      subplot(221)
    	      plot(omega/pi,phase2/pi,w/pi,thdi/pi,'+',omega/pi,thd/pi,'--')
	      title('1st eigen value')
	      ylabel('phase(*PI)')
              xlabel('frequency(*PI)')
    	      elseif ii==N
    	      subplot(222)
    	      plot(omega/pi,phase2/pi,w/pi,thdi/pi,'+',omega/pi,thd/pi,'--')
              title('2nd eigen value')
	      ylabel('phase(*PI)')
              xlabel('frequency(*PI)')
    	      elseif ii==N-1
    	      subplot(223)
    	      plot(omega/pi,phase2/pi,w/pi,thdi/pi,'+',omega/pi,thd/pi,'--')
              title('3rd eigen value')
	      ylabel('phase(*PI)')
              xlabel('frequency(*PI)')
    	      else
              subplot(224)
              plot(omega/pi,phase2/pi,w/pi,thdi/pi,'+',omega/pi,thd/pi,'--')
              title('4th eigen value')
	      ylabel('phase(*PI)')
              xlabel('frequency(*PI)')
           end
	end
       %print loop
	pause
	
  for i=N+1:-1:1	% i$@HVL\$N8GM-CM$K$D$$$F(J
    a=A(:,i);
    z=roots(a);
    ab=max(abs(z));
    fprintf('%2.0f-th eigen value.> max of |z| =%f\n',N+2-i,ab) 
    
    y=stable(a,N);	
 
    if y==1 		 % $@0BDj$+(J
      fprintf('\tstable\n')
  
      delta=2*atan(1.0/dd(i));    % $@&D$r5a$a$k(J

      a1=a(1);		% $@78?t$r5a$a$k(J
      for in=1:N+1
      a(in)=a(in)/a1;
      end
      b=flipud(a); 
      %[h,ww]=freqz(b,a,NN);		% $@FC@-$r7W;;(J
      phase=phares(a,omega,N);            	
      %phase=unwrap(angle(h))';
      %err(kp:ks)=phase(kp:ks)-thd(kp:ks);
      err=pherr(a,omega,N,thd);
      fprintf('\tdelta=%e*PI maxerr=%e*PI\n',delta/pi,max(abs(err(kp:ks)))/pi)

      if max(abs(err(kp:ks)))<pi    
	% $@:GE,6a;w$N$H$-(J
	figure(2)
 	clf
    	subplot(211)  % $@0LAjFC@-$rIA$/(J
    	plot(omega/pi,phase/pi,omega/pi,thd/pi,'--',w/pi,thdi/pi,'+')
    	title('phase response of all-pass')
    	xlabel('frequency(*PI)')
    	ylabel('phase(*PI)')

	% $@0LAj8m:9$rIA$/(J
	del=delta*del;
    	subplot(212)
    	plot(omega(kp:ks)/pi,err(kp:ks)/pi,w/pi,del/pi,'*')
    	title('phase error')
    	xlabel('frequency(*PI)')
    	ylabel('error(*PI)')
    	        	
	%pause
        fprintf('\tOK!, go to next loop\n')
        break       % $@:GE,$J$i(J REMEZ $@$X(J

      else      % if max.. $@:GE,$G$J$$$H$-(J
        fprintf('\tof no use!! try next eigen value.\n')
      end         % if max...end      

% $@0BDj$G$J$$;~(J
    else    %if unstable
      fprintf(2,'\tunstable!!\n')
    end  %if ab<1...end

    if i==1  % i=1 $@$J$iDd;_(J
      disp('cannot design any way')
      return
     end

  end   % END of for i... loop
   

  % REMEZ LOOP

  % $@6KCME@C5$7(J
  px(1)=ws;
  py(1)=err(ks);
  k=1;   % $@6KCME@?t(J
  for i=ks-1:-1:kp+1
    if (err(i+1)-err(i))*(err(i)-err(i-1)) <0
      k=k+1;
      px(k)=omega(i);
      py(k)=err(i);
    end
  end
  if k~=N
    disp('pole point not match N+1')
    return
  end

  px(N+1)=wp;
  py(N+1)=err(kp);

  %disp('pole point is')
  %disp(px/pi),disp(py/pi)

 
  if max(abs(w-px))<(0.1*pi/NN)
    break
  else  
    w=px;
  end

end  % END of while.. loop

disp('end!!')
%print out2
  
fprintf('delta=%e*PI max of |z|=%f \n',delta/pi,ab)
fprintf('N=%2.0f wp=%f ws=%f  \n',N,wp/pi,ws/pi)

save coeff.dat N wp ws delta a -ascii -double
