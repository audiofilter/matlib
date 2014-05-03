function Coefficients=ACFgena(M,N,SlopeOne,SlopeZero);

% M controls # deg. of tangency of slope Sigma at (1,1)
% N controls # deg. of tangency of slope Delta at (0,0)
% pass in (M,N,SlopeOne,SlopeZero);
% Example:  ACFgena(1,1,0,0) returns the coefficients
% [-2 3 0], standing for -2x^3 + 3x^2 + 0x^1... (there is no constant term)

if(M>0)&(N>0),
   Constraints=[1 SlopeOne zeros(1:M-1) SlopeZero zeros(1:N-1)].';
end;
if M==0,
   Constraints=[1 SlopeZero zeros(1:N-1)].';
end;
if N==0,
    Constraints=[1 SlopeOne zeros(1:M-1)].';
end;
for Row=1:M+1,
   for Column=1:M+N+1,
      Test=Factorial(Column+1-Row);
      if Test>0,
         A(Row,Column)=Factorial(Column)/Test;
      else
         A(Row,Column)=0.0;
      end;
   end;
end;
%Now we set the constraints at the origin
for Row=M+2:M+N+1,
   for Column=1:M+N+1,
      if((Row-Column)==M+1),
         A(Row,Column)=Factorial(Column);
      else
         A(Row,Column)=0.0;
      end;
    end;
end;
A
Coefficients=A\Constraints;
Reversed=Coefficients(length(Coefficients):-1:1);
Coefficients=Reversed;
return;
