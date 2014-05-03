RTD = 57.295781;
nbpe = 16;
np = 100;
oqtstate = 0; 
quad_prev = 0;
bit = zeros(1,nbpe) + i*zeros(1,nbpe);

for j=1:np
%	in(j) = 15 + 20*i;
	bit = [in(j) bit(1:nbpe-1)];
	vx = 0;
	for k=1:nbpe
		vang4=vang(bit(k));
		vx = vx + cos(vang4) + i*sin(vang4);
	end         
	vx = vx/nbpe                                                                          
	oang4 = angle(vx);
	if (oang4 <= 0.) 
		oang4 = oang4 + 2.*pi;
	end  
%************ output quadrant translator for QPSK ***************************/                                 
	quad_now=ceil(oang4*RTD/90);
	quad_now = floor(quad_now/4);  

% keep track of quadrant cross-overs */
	if (quad_prev==3) & (quad_now==0)
	         	oqtstate = oqstate + 1;
	  	 	oqtstate = floor(oqtstate/4);  
	end
	if (quad_prev==0) & (quad_now==3) 
    			oqtstate = oqstate + 3;        
	        	oqtstate = floor(oqtstate/4);
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
	ang(j) = oang;
%/* store the current quadrant number */  
	quad_prev = quad_now;
	out(j) = in(j)*exp(-i*ang(j));
end
				
