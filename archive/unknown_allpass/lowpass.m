% LOWPASS ALLPASS FILTER USING EIGEN METHOD
clear
NN=600;
omega=pi/NN*(0:NN-1);
wp=input('wp=');
fprintf('wp= %f pi \n',wp)
wp=wp*pi;
kp=wp/pi*NN;
tau=input('tau=');
N=input('N=');
%kj=input('kj=');
%amp=input('amp=');
if tau>N
  ud=1;
else
  ud=0;
end
w(N+1:-1:1)=wp/(N+1)*(1:N+1);
%disp('freq point is')
%disp(w)

thd=-tau*omega;
%thd=-10*omega+2*pi*sin(omega);
delta=0.1;


while 1

thdi=-tau*w;
%thdi=-10*w+2*pi*sin(w);

for i=1:N+1
  for n=1:N+1
    fai=(n-1)*w(i)-0.5*(N*w(i)+thdi(i));
    P(i,n)=sin(fai);
    Q(i,n)=(-1)^(i+ud)*cos(fai);
  end
  del(i)=(-1)^(i+ud);
end
%disp('Matrix is')
%disp(Q\P)



[X,D]=eig(P\Q);   		% 固有値を求める
[d,k]=sort(abs(diag(D)));       % 固有値をソート
dd=diag(D);
dd=dd(k);
A=X(:,k);
disp('eigen value is')
disp(dd')
disp('eigen vector is')
disp(A)

% 各固有値による特性
	figure(1)
	clf
	for ii=N+1:-1:N-2
  		a2=A(:,ii);
  		delta2=2*atan(1.0/dd(ii));
  		a12=a2(1);
  		a2=a2/a12;
  		%b2=flipud(a2); 
  		%h2=freqz(b2,a2,omega);
  		%phase2=unwrap(angle(h2));
		phase2=phares(a2,omega,N);
  		if ii==N+1  
    		 subplot(221)
    		 plot(omega/pi,phase2/pi,w/pi,thdi/pi,'o')
    	        elseif ii==N
    		 subplot(222)
    		 plot(omega/pi,phase2/pi,w/pi,thdi/pi,'o')
    	        elseif ii==N-1
    		 subplot(223)
    		 plot(omega/pi,phase2/pi,w/pi,thdi/pi,'o')
    	        else
                 subplot(224)
                 plot(omega/pi,phase2/pi,w/pi,thdi/pi,'o')
                end
	end
      

for i=N+1:-1:1		% i番目の固有値について
  a=A(:,i);
  z=roots(a);
  ab=max(abs(z));
  fprintf('%2.0f-th eigen value.> max of |z| =%f\n',N+2-i,ab) 

  y=stable(a,N);

  if y==1 		 % 安定か
    fprintf('\tstable\n')

% 安定の時の処理  

  delta=2*atan(1.0/dd(i));    % δを求める

  a1=a(1);		% 係数を求める
  a=a/a1;
  %b=flipud(a); 
  %[h,ww]=freqz(b,a,NN);		% 特性を計算

  phase=phares(a,omega,N);
  err=pherr(a,omega,N,thd);

  fprintf('\tdelta=%e*PI maxerr=%e*PI\n',delta/pi,max(abs(err(1:kp)))/pi)

  if max(abs(err(1:kp)))<pi    
	% 最適近似のとき
	figure(2)
 	clf
    	subplot(211)  % 位相特性を描く
    	plot(omega/pi,phase/pi,w/pi,thdi/pi,'o')
    	title('phase response of all-pass')
    	xlabel('frequancy(*PI)')
    	ylabel('phase(*PI)')

	del=delta*del;   % 位相誤差を描く
    	subplot(212)
    	plot(omega(1:kp)/pi,err(1:kp)/pi,w/pi,del/pi,'*')
    	title('phase error')
    	xlabel('frequancy(*PI)')
    	ylabel('error(*PI)')
    	pause

        fprintf('\tOK!, go to next loop\n')
        break       % 安定で最適なら REMEZ へ

  else      % if max.. 最適でないとき
    fprintf('\tof no use!! try next eigen value.\n')
  end         % if max...end      

% 安定でない時
  else    %if unstable
    fprintf('\tunstable!! try next eigen value.\n')
  end  %if ab<1...end


  if i==1  % i=1 なら停止
    disp('cannot design any way')
    return
  end

end   % END of while loop
   

 % REMEZ LOOP

% 極値点探し
k=1;   % 極値点数
for i=2:kp-1
  if (err(i+1)-err(i))*(err(i)-err(i-1)) <0
    px(k)=omega(i);
    py(k)=err(i);
    k=k+1;
  end
end

%disp('pole point is')
%disp(px/pi),disp(py/pi)

px(N+1)=wp;
py(N+1)=err(kp);
 
if max(abs(w-px))<0.01
  break
else  
  w=px;
end

end  % END of for.. loop

disp('end!!')

  
fprintf('delta=%e*PI max of |z|=%f \n',delta/pi,ab)
fprintf('N=%2.0f wp=%f \n',N,wp/pi)

save coeff.dat N wp delta a -ascii -double