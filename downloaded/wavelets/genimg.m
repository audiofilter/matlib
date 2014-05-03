function y=genimg(typ,sizex,sizey,frqx,frqy)

%  GENIMG  Generates one of 11 different kinds of images
%          useful as test inputs for wavelet transformation
%          and multiresolution analysis.
%
%          Y = GENIMG (TYP) generates a 128x128 image of 
%          type TYP.
%
%          Y = GENIMG (TYP,SIZX,SIZY) forces the image to be
%          SIZX x SIZY sized. 
%
%          Y = GENIMG (TYP,SIZX,SIZY,FRQX,FRQY) changes the
%          frequencies used to generate the images. The default
%          value is 1 for both axis.    
%
%
%          See also: WTDEMO, SHOW, WT2D.


%-------------------------------------------------------- 
% Copyright (C) 1994, 1995, 1996, by Universidad de Vigo 
%                                                      
%                                                      
% Uvi_Wave is free software; you can redistribute it and/or modify it      
% under the terms of the GNU General Public License as published by the    
% Free Software Foundation; either version 2, or (at your option) any      
% later version.                                                           
%                                                                          
% Uvi_Wave is distributed in the hope that it will be useful, but WITHOUT  
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or    
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License    
% for more details.                                                        
%                                                                          
% You should have received a copy of the GNU General Public License        
% along with Uvi_Wave; see the file COPYING.  If not, write to the Free    
% Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.             
%                                                                          
%       Author: Sergio J. Garcia Galan
%       e-mail: Uvi_Wave@tsc.uvigo.es
%--------------------------------------------------------



if nargin<4
	frqx=1;
	frqy=1;
end;

if nargin<2
	sizex=128;
	sizey=128;
end;

frqx=128/sizex*frqx;
frqy=128/sizey*frqy;

if typ==0,
	disp('Wavelet test image');
	y=zeros(sizey,sizex);
	a=floor(sizex/(8*frqx));
	b=floor(sizey/(8*frqy));
	y(b+1,a+1:sizex-a)=ones(1,sizex-2*a);
	y(sizey-b,a+1:sizex-a)=ones(1,sizex-2*a);
	y(b+1:sizey-b,a+1)=ones(sizey-2*b,1);
	y(b+1:sizey-b,sizex-a)=ones(sizey-2*b,1);
	db=(sizey-2*b)/(sizex-2*a);
	b=b+1;
	for i=a+1:sizex-a-1,
		y(b,i)=1;
		y(sizey-b,i)=1;
		b=b+db;
	end;
end;

if typ==1,
	disp('Sharp wavy image');
	frqx=frqx*0.1;
	frqy=frqy*0.1;
	for j=1:sizey
		a(j,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x).*[linspace(0,sizey*frqy,sizey)]';
	end	
	y=sin(a);		
end;


if typ==2,
	disp('Diagonal image');
	frqx=frqx*1;
	frqy=frqy*1;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x)+[linspace(0,sizey*frqy,sizey)]';
	end	
	y=sin(a);		
end;


if typ==3,
	disp('Horizon image');
	frqx=frqx*0.5;
	frqy=frqy*0.04;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x)./([linspace(0,sizey*frqy,sizey)]'+1);
	end	
	y=sin(a);		
end;


if typ==4,
	disp('Square filled image');
	frqx=frqx*0.5;
	frqy=frqy*0.5;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	a=sin(a);
	for x=1:sizex
		b(:,x)=[linspace(0,sizey*frqy,sizey)]';
	end	
	b=sin(b);
	y=a+b;
end;


if typ==5,
	disp('Growing squares image');
	frqx=frqx*0.05;
	frqy=frqy*0.05;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
		a(y,:)=a(y,:).*a(y,:);
	end	
	a=sin(a);
	for x=1:sizex
		b(:,x)=[linspace(0,sizey*frqy,sizey)]';
		b(:,x)=b(:,x).*b(:,x);
	end	
	b=sin(b);
	y=a+b;
end;


if typ==6,
	disp('Dust among bars image');
	frqx=frqx*0.25;
	frqy=frqy*0.25;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x)+([linspace(0,sizey*frqy,sizey)]'+1);
	end	
	y=sin(a.^2);		
end;


if typ==7,
	disp('Wavy diagonals image');
	frqx=frqx*0.05;
	frqy=frqy*0.05;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x)+([linspace(0,sizey*frqy,sizey)]'+1);
	end	
	y=sin(a.^2)+cos(a);		
end;


if typ==8,
	disp('Round wavy 1 image');
	frqx=frqx*0.05;
	frqy=frqy*0.05;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x).*([linspace(0,sizey*frqy,sizey)]');
	end	
	y=sin(a.^2)+cos(a);		
end;


if typ==9,
	disp('Round wavy 2 image');
	frqx=frqx*0.05;
	frqy=frqy*0.05;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		a(:,x)=a(:,x).*[linspace(0,sizey*frqy,sizey)]';
	end	
	y=sin(a)+cos(a.^2);		
end;


if typ==10,
	disp('Multiple square image');
	frqx=frqx*0.1;
	frqy=frqy*0.1;
	for y=1:sizey
		a(y,:)=linspace(0,sizex*frqx,sizex);
	end	
	for x=1:sizex
		b(:,x)=([linspace(0,sizey*frqy,sizey)]');
		a(:,x)=a(:,x)+b(:,x);
	end	
	y=cos(sin(b.^2));
	y=y+y';		
end;
