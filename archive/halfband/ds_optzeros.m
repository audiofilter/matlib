function optZeros = ds_optzeros( n, opt )
%optZeros = ds_optzeros( n, opt )
%A helper function for the synthesizeNTF function of the Delta-Sigma Toolbox.
%Returns the zeros which minimize the in-band noise power of 
%a delta-sigma modulator's NTF.

if n==1
    optZeros=0;
elseif n==2
    if opt==1
	optZeros=sqrt(1/3);
    else
	optZeros=0;
    end
elseif n==3
    optZeros=[sqrt(3/5) 0];
elseif n==4
    if opt==1
	discr = sqrt(9./49-3./35);
	tmp = 3./7;
	optZeros=sqrt([tmp+discr tmp-discr]);
    else
	optZeros=[0 sqrt(5/7)];
    end
elseif n==5
    discr = sqrt(25./81-5./21);
    tmp = 5./9;
    optZeros=sqrt([tmp+discr tmp-discr 0]);
elseif n==6
    if opt==1
	optZeros=[0.93246935636220 0.66120925285410 0.23861957806940];
    else
	discr = sqrt(56.)/33;
	tmp = 7./11;
	optZeros=sqrt([0 tmp+discr tmp-discr]);
    end
elseif n==7
    optZeros=[ 0.94910794020414 0.74153083158296 0.40584562459724 0];
elseif n==8
    optZeros=[ 0.96029008224551 0.79666675114317 0.52553208300091 0.18343409158171];
elseif n==9
    optZeros=[ 0.9685 0.8301 0.6222 0.3216 0 ];
elseif n==10
    optZeros=[ 0.9674 0.8847 0.6953 0.4217 0.1452 ];
elseif n==11
    optZeros=[ 0.9720 0.9010 0.7465 0.5252 0.1109 0 ];
else
    fprintf(1,'Optimized zeros for n > 8 are not available.\n');
    return;
end

% Sort the zeros and replicate them.
z = sort(optZeros);
optZeros = zeros(n,1);
m=1;
if(rem(n,2)==1)
    optZeros(1) = z(1);
    z = z(2:length(z));
    m=m+1;
end
for(i=1:length(z))
    optZeros(m)   =  z(i);
    optZeros(m+1) = -z(i);
    m = m+2;
end

