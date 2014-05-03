%$Id: fir_rc.m,v 1.1 1997/09/25 17:09:24 kirke Exp $
% FIR_RC
fs=0.15375;
m=4; 
k=2;
N=2*m*k-1;                       
Ns=(N+1)*(m-1)/(2*m); 
Nsp1=Ns+1;
Nh=(N-1)/2; 
Nu=Ns;
inc = 2*PI()*(1-fs)/Nsp1;
	for (i=0;i<Nsp1;i++) y.m[i][0] = -1/m;
	// Initial extermal frequencies
	for (i=0;i<Nsp1;i++) w[i] = TWOPI*fs + inc*i;
  
	for (i=0;i<Nsp1;i++) {
		for (j=0;j<Nsp1;j++) m_cos.m[i][j] = 2*cos(w[j]);
	}  

	Matrix iv=Inv(m_cos);
	h =  iv*y;    
	for (i=0;i<Nsp1;i++) printf("%g ",h.m[i][0]);
	printf("New matrix");
}