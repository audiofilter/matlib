function [x,w]=karmark(A,x,c,epsi)

% function [x,w]=karmark(A,x,c,epsi)
%
% Lineare programming according to Karmarkar see linprok.m

% Copyright: All software, documentation, and related files in this
%            distribution are Copyright (c) 1992 LNT, University of Erlangen
%            Nuernberg, FRG, 1992 
%
% Permission is granted for use and non-profit distribution providing that this
% notice be clearly maintained. The right to distribute any portion for profit
% or as part of any commercial product is specifically reserved for the author.
%
% Since this program is free of charge we provide absolutely no warranty.
% The entire risk as to the quality and the performance of the program is
% with the user. Should it prove defective, the user user assumes the cost
% of all necessary serrvicing, repair or correction. 

[ln,lm]=size(A);
xh2 = x.^2;
fehleralt=epsi*ones(size(c));

% Iterationen
it = 0;
stp=1;
while stp,
   it = it+1;
   AmD2 = A.*xh2(:,ones(1,ln))';
%   AmD2=A.*kron(ones(1,ln)',xh2(:)');     %  
   AmD2mA=AmD2*A';                        %
   con=cond(AmD2mA);                      %  Loesung des ueberbest. Gl.-syt.
   if con < 1e10;                         %  D*A=D*c mit Hilfe der Chol.-zerl.,
     R=chol(AmD2mA);                      %  falls Kondition nicht zu schlecht
     z=R'\(AmD2*c);                       %  
     w=R\z;                               %  ansonsten mit
   else                                   % 
     AmD = (A.*kron(ones(1,ln)',x(:)'))'; %  QR-Zerlegung
     w = AmD \ (x.*c);                    %
   end                                    %

   fehler=c-A'*w;
   delta=xh2.*fehler;   
   beta=.97/(max(delta./x));
   x=x-beta*delta;   
   xh2=x.^2;
   
   r1=max(abs(fehler/max(abs(fehler))-fehleralt/max(abs(fehleralt))));
   if (r1<epsi) | (it>35) | (fehler==0) , stp=0;
   else,
    fehleralt=fehler;
%   plot(1:lm,abs(fehler),'og'); xlabel(['r = ' num2str(r1),'  Kondition = '...
%          num2str(con)]);
   end;
end;
