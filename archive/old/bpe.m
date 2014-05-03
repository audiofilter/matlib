bit = [in bit(1:nbpe-1)];
vx = 0;
for kbpe=1:nbpe
	vang4=vang(bit(kbpe));
	vx = vx + cos(vang4) + i*sin(vang4);
end         
vx = vx/nbpe;                                                                          
oang4 = angle(vx);

clear kbpe;
clear vang4;
clear vx;

if (oang4 <= 0.) 
	oang4 = oang4 + 2.*pi;
end  

if (oang4 >= 2*pi)
	oang4 = 2*pi-0.000001;
end
%************ output quadrant translator for QPSK ***************************/                                 
quad_now = floor(oang4*RTD/90);
quad_now = rem(quad_now,4);  

% keep track of quadrant cross-overs */
if (quad_prev==3) & (quad_now==0)
       	oqtstate = oqtstate + 1;
 	oqtstate = rem(oqtstate,4);  
end
if (quad_prev==0) & (quad_now==3) 
	oqtstate = oqtstate + 3;
       	oqtstate = rem(oqtstate,4);
end     
%******************* end output quadrant translator for QPSK *****************/
oang = oang4/4.;
oang = oang - pi/4.0;  
	
%* compensate for quadrant cross-overs */
oang = oang + oqtstate*pi/2;                        
if (oang <= 0.) 
	oang = oang + 2.*pi;
end
%* keep track of the phase introduced */
ang = oang;

clear oang;
clear oang4;

%/* store the current quadrant number */  
quad_prev = quad_now;
				
