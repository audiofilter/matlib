function [cc]= rs_encode(mm,tt,dd)

% Encoder for Reed-Solomon codes
% Usage: [cc]= rs_encode(mm,tt,dd)
%
% mm       : RS code over GF(2**mm) with mm<=11. Example mm=4
% tt       : number of errors that can be corrected. Example tt=3
% dd(kk)   : data. Example  dd=[8, 6, 8, 1, 2, 4, 15, 9, 9]
% cc(nn)   : codeword. Example [8, 6, 8, 1, 2, 4, 15, 9, 9, 7, 6, 11, 2, 4, 3]

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
dd=fliplr(dd);

% COEFFICIENT ORDER
% In the following algorithm, the coefficient order [a b c ...] is
% a + b*x + c*x^2 + ...

if(size(dd,2)==1), dd=dd'; end
ll=length(dd);
if(ll==kk)    data=dd; 
elseif(ll>kk) data([1:kk])=dd([1:kk]);
elseif(ll<kk) data=[dd, zeros(1,kk-ll)]; endif

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

% take the string of symbols in data[i], i=0..(k-1) and encode systematically
%   to produce 2*tt parity symbols in bb[0]..bb[2*tt-1]
%   data[] is input and bb[] is output in polynomial form.
%   Encoding is done by using a feedback shift register with appropriate
%   connections specified by the elements of gg[], which was generated above.
%   Codeword is   c(X) = data(X)*X**(nn-kk)+ b(X)          */

  bb([1:nn-kk])=0;  
  for i=kk:-1:1
      feedback = index_of(1+bin_exor(data(i),bb(nn-kk))) ;
      if (feedback != -1)
          for j=nn-kk:-1:2
             if (gg(j) != -1)
                bb(j) = bin_exor(bb(j-1),alpha_to(1+rem((gg(j)+feedback),nn))) ;
             else
                bb(j) = bb(j-1) ;
	     end
	  end
          bb(1) = alpha_to(1+rem((gg(1)+feedback),nn)) ;
      else
          for j=nn-kk:-1:2
             bb(j) = bb(j-1) ;
	  end
          bb(1) = 0 ;
      end
  end

if(size(bb,2)==1), bb=bb'; end
  
cc=[bb,dd];

% obtain the original coefficient order
cc=fliplr(cc);

end  

