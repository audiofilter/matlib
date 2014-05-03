function [dd]= rs_decode(mm,tt,cc)

% Decoder for Reed-Solomon codes
% Usage: [dd]= rs_decode(mm,tt,cc)
%
% mm       : RS code over GF(2**mm) with mm<=11. Example mm=4
% tt       : number of errors that can be corrected. Example tt=3
% cc(mm)   : data. Example cc=[8, 6, 8, 1, 2, 4, 15, 9, 9, 7, 6, 11, 2, 4, 3]
% dd(kk)   : output. Example  [8, 6, 8, 1, 2, 4, 15, 9, 9]

% nn = 2**mm -1 : length of codeword.
% kk = nn-2*tt  : length of data.


%   This program is an encoder/decoder for Reed-Solomon codes. Encoding is in
%   systematic form, decoding via the Berlekamp iterative algorithm.
%   In the present form , the constants mm, nn, tt, and kk=nn-2tt must be
%   specified  (the double letters are used simply to avoid clashes with
%   other n,k,t used in other programs into which this was incorporated!)
%   Also, the irreducible polynomial used to generate GF(2**mm) must also be
%   entered -- these can be found in Lin and Costello, and also Clark and Cain.

%   The representation of the elements of GF(2**m) is either in index form,
%   where the number is the power of the primitive element alpha, which is
%   convenient for multiplication (add the powers modulo 2**m-1) or in
%   polynomial form, where the bits represent the coefficients of the
%   polynomial representation of the number, which is the most convenient form
%   for addition.  The two forms are swapped between via lookup tables.
%   This leads to fairly messy looking expressions, but unfortunately, there
%   is no easy alternative when working with Galois arithmetic.

%   The code is not written in the most elegant way, but to the best
%   of my knowledge, (no absolute guarantees!), it works.
%   However, when including it into a simulation program, you may want to do
%   some conversion of global variables (used here because I am lazy!) to
%   local variables where appropriate, and passing parameters (eg array
%   addresses) to the functions  may be a sensible move to reduce the number
%   of global variables and thus decrease the chance of a bug being introduced.

%   This program does not handle erasures at present, but should not be hard
%   to adapt to do this, as it is just an adjustment to the Berlekamp-Massey
%   algorithm. It also does not attempt to decode past the BCH bound -- see
%   Blahut "Theory and practice of error control codes" for how to do this.

%              Simon Rockliff, University of Adelaide   21/9/89

%                  Notice
%                 --------
%   This program may be freely modified and/or given to whoever wants it.
%   A condition of such distribution is that the author's contribution be
%   acknowledged by his name being left in the comments heading the program,
%   however no responsibility is accepted for any financial or other loss which
%   may result from some unforseen errors or malfunctioning of the program
%   during use.
%                                 Simon Rockliff, 26th June 1991
%
%   Original code in C
%   Modifications for Octave: F. Arguello


nn = 2**mm -1; % length of codeword.
kk = nn-2*tt;  % length of data.

% reverse the coefficient order of data
cc=fliplr(cc);

% COEFFICIENT ORDER
% In the following algorithm, the coefficient order [a b c ...] is
% a + b*x + c*x^2 + ...

if(size(cc,2)==1) cc=cc'; end
ll=length(cc);
if(ll==nn)    recd=cc; 
elseif(ll>nn) recd([1:nn])=cc([1:nn]);
elseif(ll<nn) recd=[cc, zeros(1,nn-ll)]; endif

% irreducible polynomial coeffts. pp(mm+1)

if (mm==0) pp=[1];
elseif (mm==1)  pp=[1 1];
elseif (mm==2)  pp=[1 1 1];
elseif (mm==3)  pp=[1 1 0 1];
elseif (mm==4)  pp=[1 1 0 0 1];
elseif (mm==5)  pp=[1 0 1 0 0 1];
elseif (mm==6)  pp=[1 1 0 0 0 0 1];
elseif (mm==7)  pp=[1 1 0 0 0 0 0 1];
elseif (mm==8)  pp=[1 0 1 1 1 0 0 0 1];
elseif (mm==9)  pp=[1 0 0 0 1 0 0 0 0 1];
elseif (mm==10) pp=[1 0 0 1 0 0 0 0 0 0 1];
elseif (mm==11) pp=[1 0 1 0 0 0 0 0 0 0 0 1];
endif

% generate GF(2**mm) from the irreducible polynomial p(X) in pp[0]..pp[mm]
% lookup tables:  index->polynomial form   alpha_to[] contains j=alpha**i;
%                 polynomial form -> index form  index_of[j=alpha**i] = i
% alpha=2 is the primitive element of GF(2**mm)

  mask = 1 ;
  alpha_to(mm+1) = 0 ;
  for i=1:mm
     alpha_to(i) = mask ;
     index_of(alpha_to(i)+1) = i-1 ;
     if (pp(i)!=0) alpha_to(mm+1) = bin_exor(alpha_to(mm+1),mask); end
     mask = mask*2;
  end
  index_of(alpha_to(mm+1)+1) = mm;
  mask = floor(mask/2);
  for i=mm+2:nn
     if (alpha_to(i-1) >= mask)
        alpha_to(i) = bin_exor(alpha_to(mm+1),bin_exor(alpha_to(i-1),mask)*2);
     else alpha_to(i) = (alpha_to(i-1))*2;
     end
     index_of(alpha_to(i)+1) = i-1;
  end
  index_of(1) = -1 ; alpha_to(nn+1)=0;
  
% Obtain the generator polynomial of the tt-error correcting, length
% nn=(2**mm -1) Reed Solomon code  from the product of (X+alpha**i), i=1..2*tt

  gg(1) = 2 ;    % primitive element alpha = 2  for GF(2**mm)  
  gg(2) = 1 ;    % g(x) = (X+alpha) initially 
  for i=3:nn-kk+1
      gg(i) = 1 ;
      for j=i-1:-1:2
        if (gg(j) != 0)  
	     gg(j) = bin_exor(gg(j-1), alpha_to(1+rem(index_of(gg(j)+1)+i-1,nn))) ;
        else gg(j) = gg(j-1) ; endif
      end
      gg(1) = alpha_to(1+rem(index_of(gg(1)+1)+i-1,nn)) ; % gg(1) can never be zero 
  end
  % convert gg() to index form for quicker encoding 
  gg([1:nn-kk+1]) = index_of(gg([1:nn-kk+1])+1);

  for i=1:nn
     recd(i) = index_of(1+recd(i)) ; % put recd(i) into index form 
  end

% assume we have received bits grouped into mm-bit symbols in recd[i],
% i=0..(nn-1),  and recd[i] is index form (ie as powers of alpha).
% We first compute the 2*tt syndromes by substituting alpha**i into rec(X) and
% evaluating, storing the syndromes in s[i], i=1..2tt (leave s[0] zero) .
% Then we use the Berlekamp iteration to find the error location polynomial
% elp[i].   If the degree of the elp is >tt, we cannot correct all the errors
% and hence just put out the information symbols uncorrected. If the degree of
% elp is <=tt, we substitute alpha**i , i=1..n into the elp to get the roots,
% hence the inverse roots, the error location numbers. If the number of errors
% located does not equal the degree of the elp, we have more than tt errors
% and cannot correct them.  Otherwise, we then solve for the error value at
% the error location and correct the error.  The procedure is that found in
% Lin and Costello. For the cases where the number of errors is known to be too
% large to correct, the information symbols as received are output (the
% advantage of systematic encoding is that hopefully some of the information
% symbols will be okay and that if we are in luck, the errors are in the
% parity part of the transmitted codeword).  Of course, these insoluble cases
% can be returned as error flags to the calling routine if desired.   
 
   count=0; 
   syn_error=0;
%  first form the syndromes 
   for i=1:nn-kk
      s(i+1) = 0;
      for j=0:nn-1
        if (recd(j+1)!=-1)
%          recd(j) in index form 
           s(i+1) = bin_exor(s(i+1),alpha_to(1+rem(recd(j+1)+i*j,nn))) ;  
	 end
      end
%   convert syndrome from polynomial form to index form  
%   set flag if non-zero syndrome => error 
      if (s(i+1)!=0)  syn_error=1 ;  end 
      s(i+1) = index_of(1+s(i+1)) ;
   end


   if (syn_error)      % if errors, try and correct 

% compute the error location polynomial via the Berlekamp iterative algorithm,
% following the terminology of Lin and Costello :   d(u) is the 'mu'th
% discrepancy, where u='mu'+1 and 'mu' (the Greek letter!) is the step number
% ranging from -1 to 2*tt (see L&C),  l(u) is the
% degree of the elp at that step, and u_l(u) is the difference between the
% step number and the degree of the elp.

% initialise table entries 
      d(1) = 0 ;           % index form 
      d(2) = s(2) ;        % index form 
      elp(1,1) = 0 ;      % index form 
      elp(2,1) = 1 ;      % polynomial form 
      for i=1:nn-kk-1
         elp(1,i+1) = -1 ;  % index form 
         elp(2,i+1) = 0 ;   % polynomial form 
      endfor
      l(1) = 0 ;
      l(2) = 0 ;
      u_lu(1) = -1 ;
      u_lu(2) = 0 ;
      u = 0 ;

      control=0;
      while(control==0)
        u++ ;
        if (d(u+1)==-1)
            l(u+2) = l(u+1) ;
            for i=0:l(u+1)
                elp(u+2,i+1) = elp(u+1,i+1) ;
                elp(u+1,i+1) = index_of(1+elp(u+1,i+1)) ;
            endfor
        else
% search for words with greatest u_lu(q) for which d(q)!=0 
            q = u-1 ;
            while ((d(q+1)==-1) && (q>0)) q-- ; endwhile
% have found first non-zero d(q)  
            if (q>0)
	       for j=q-1:-1:0
                 if ((d(j+1)!=-1) && (u_lu(q+1)<u_lu(j+1))) q = j ; end
               endfor
            endif
	    
% have now found q such that d(u)!=0 and u_lu(q) is maximum 
% store degree of new elp polynomial 
            if (l(u+1)>l(q+1)+u-q)  l(u+2) = l(u+1) ;
            else  l(u+2) = l(q+1)+u-q ;
            endif
% form new elp(x) 
            for i=0:nn-kk-1
	        elp(u+2,i+1) = 0 ;
            endfor
            for i=0:l(q+1)
              if (elp(q+1,i+1)!=-1)
                elp(u+2,i+u-q+1) = alpha_to(1+rem(d(u+1)+nn-d(q+1)+elp(q+1,i+1),nn)) ;
	      endif
            endfor
            for i=0:l(u+1)
              elp(u+2,i+1) = bin_exor(elp(u+2,i+1),elp(u+1,i+1)) ;
              elp(u+1,i+1) = index_of(1+elp(u+1,i+1)) ;  
	      % convert old elp value to index
            endfor
        endif
        u_lu(u+2) = u-l(u+2) ;

% form (u+1)th discrepancy 
        if (u<nn-kk)    % no discrepancy computed on last iteration 
            if (s(u+2)!=-1)
                   d(u+2) = alpha_to(1+s(u+2)) ;
            else
              d(u+2) = 0 ;
            endif
            for i=1:l(u+2)
              if ((s(u+2-i)!=-1) && (elp(u+2,i+1)!=0))
                d(u+2)=  bin_exor(d(u+2),alpha_to(1+rem(s(u+2-i)+                index_of(1+elp(u+2,i+1)),nn))) ;
	      endif
            endfor
            d(u+2) = index_of(1+d(u+2)) ;    % put d(u+1) into index form 
        endif

        if((u<nn-kk) && (l(u+2)<=tt)) control=0; 
        else control=1;
        endif
      endwhile

      u++ ;
      if (l(u+1)<=tt)         % can correct error 
% put elp into index form 
         for i=0:l(u+1)   
	    elp(u+1,i+1) = index_of(1+elp(u+1,i+1)) ;
         endfor
% find roots of the error location polynomial 
         for i=1:l(u+1)
           reg(i+1) = elp(u+1,i+1) ;
         endfor
         count = 0 ;
         for i=1:nn
             q = 1 ;
             for j=1:l(u+1)
                if (reg(j+1)!=-1)
                   reg(j+1) = rem(reg(j+1)+j,nn) ;
                    q = bin_exor(q,alpha_to(1+reg(j+1))) ;
		endif
             endfor 
             if (!q)        % store root and error location number indices 
                root(count+1) = i;
                loc(count+1) = nn-i ;
                count++ ;
             endif
         endfor
         if (count==l(u+1))    % no. roots = degree of elp hence <= tt errors 
% form polynomial z(x) 
           for i=1:l(u+1)        % Z(0) = 1 always - do not need 
               if ((s(i+1)!=-1) && (elp(u+1,i+1)!=-1))
                  z(i+1)=bin_exor(alpha_to(1+s(i+1)),alpha_to(1+elp(u+1,i+1))) ;
               elseif ((s(i+1)!=-1) && (elp(u+1,i+1)==-1))
                  z(i+1) = alpha_to(1+s(i+1)) ;
               elseif ((s(i+1)==-1) && (elp(u+1,i+1)!=-1))
                  z(i+1) = alpha_to(1+elp(u+1,i+1)) ;
               else
                  z(i+1) = 0 ;
	       endif
               for j=1:i-1
                 if ((s(j+1)!=-1) && (elp(u+1,i-j+1)!=-1))
                    z(i+1) = bin_exor(z(i+1),alpha_to(1+rem(elp(u+1,i-j+1)+s(j+1),nn)));
		 endif
	       endfor
               z(i+1) = index_of(1+z(i+1)) ;         % put into index form 
           endfor 

  % evaluate errors at locations given by error location numbers loc(i) 
           for i=0:nn-1
               err(i+1) = 0 ;
               if (recd(i+1)!=-1)        % convert recd() to polynomial form 
                 recd(i+1) = alpha_to(1+recd(i+1)) ;
               else  recd(i+1) = 0 ;
	       endif
           endfor

           for i=0:l(u+1)-1    % compute numerator of error term first 
              err(1+loc(i+1)) = 1;       % accounts for z(0) 
              for j=1:l(u+1)
                if (z(j+1)!=-1)
                  err(1+loc(i+1)) = bin_exor(err(1+loc(i+1)), alpha_to(1+rem(z(j+1)+j*root(i+1),nn))) ;
		endif
	      endfor
              if (err(1+loc(1+i))!=0)
                 err(1+loc(i+1)) = index_of(1+err(1+loc(i+1))) ;
                 q = 0 ;     % form denominator of error term 
                 for j=0:l(u+1)-1
                   if (j!=i)
                     q=q+index_of(1+bin_exor(1,alpha_to(1+rem(loc(j+1)+root(i+1),nn)))) ;
		   endif
		 endfor
                 q = rem(q,nn) ;
                 err(1+loc(i+1)) = alpha_to(1+rem(err(1+loc(i+1))-q+nn,nn)) ;
                 recd(1+loc(i+1)) = bin_exor(recd(1+loc(i+1)),err(1+loc(i+1)));
		 % recd(i) must be in polynomial form
              endif
           endfor
         else     
           for i=0:nn-1        % could return error flag if desired 
               if (recd(i+1)!=-1)        % convert recd() to polynomial form 
                 recd(i+1) = alpha_to(1+recd(i+1)) ;
               else  recd(i+1) = 0 ;     % just output received codeword as is 
	       endif
	   endfor
	 endif      
      else         % elp has degree has degree >tt hence cannot solve 
          for i=0:nn-1       % could return error flag if desired 
             if (recd(i+1)!=-1)        % convert recd() to polynomial form 
               recd(i+1) = alpha_to(1+recd(i+1)) ;
             else  recd(i+1) = 0 ;     % just output received codeword as is
	     endif
          endfor 
      endif
            
   else       % no non-zero syndromes => no errors: output received codeword 
       for i=0:nn-1
          if (recd(i+1)!=-1)        % convert recd() to polynomial form 
             recd(i+1) = alpha_to(1+recd(i+1)) ;
          else  recd(i+1) = 0 ;
          endif
       endfor
   endif
   
dd=recd([2*tt+1:ll]);
if(size(dd,2)==1) dd=dd'; end

% obtain the original coefficient order
dd=fliplr(dd);

end
