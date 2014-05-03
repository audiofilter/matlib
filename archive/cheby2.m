From: "Thomas P. Krauss" <krauss@ecn.purdue.edu>
Subject: Re: Chebyshev Polynomials Tables
Newsgroups: sci.math,comp.lang.basic.visual.misc,comp.soft-sys.matlab,sci.math.num-analysis
To: David Copperhead <davidcopperhead@rocketmail.com>
Date: Wed, 08 Oct 1997 15:06:46 -0600
Organization: Purdue University
Reply-To: krauss@ecn.purdue.edu
Xref: voder comp.lang.basic.visual.misc:189597 comp.soft-sys.matlab:33448 sci.math:203626 sci.math.num-analysis:34823
Path: voder!su-news-feed2.bbnplanet.com!su-news-hub1.bbnplanet.com!cpk-news-hub1.bbnplanet.com!news.bbnplanet.com!newsfeed.internetmci.com!128.174.5.49!vixen.cso.uiuc.edu!news.indiana.edu!news.iupui.edu!mozo.cc.purdue.edu!news
Lines: 54
Distribution: inet
Message-ID: <343BF5D9.5E24@ecn.purdue.edu>
References: <343713e9.47594769@204.127.4.22> <3438D259.68BF1D9@maths.ex.ac.uk> <61dod4$5q2$1@hermes.louisville.edu> <343A8855.1C73@ecn.purdue.edu> <343b0c3b.8833460@204.127.4.22>
NNTP-Posting-Host: msegmac5.ecn.purdue.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: Mozilla 3.01-C-MACOS8 (Macintosh; I; PPC)

David Copperhead wrote:
> Hi Thomas,
> thanks for the function example, basically I was trying to
> plot a Chebyshev magnitude response with the following function,
> I am using a table of chebyshev polynomials and would like
> to impliment your algorithm to it,
> Any help is greatly appreciated.

Sure, here is how you could modify your function to use
the function I posted.  Note the use of "polyval".

Cheers,
  Tom

-------
function cheby(t,n,f,w,r)
% Chebyshev Lowpass Highpass Attenuation plotting routine.
% to call this function, do the following
% cheby(t,n,f,w,r); substitute the variables of course dummy!
% t=0; type of filter, lowpass=0, highpass=1
% n=5; % number of poles
% f=50; % 3dB cutoff frequency
% w=150; % graph end point, desired attenuation frequncy
% r=.1; % passband ripple in dB

e=((10^(r/10))-1)^0.5; % passband ripple factor 
B=1/n * acosh(1/e);

Tn = tchebycheff(n);
for x = 1:w;   % number of points
 if (t==0) 
  Omega=(x/f) * cosh(B); % lowpass
 elseif (t==1)
  Omega=(x\f) * cosh(B); % highpass
 end;

 Cn = polyval(Tn,Omega);

 wx(x)=x; % frequency points
 AdB(x) = -(10 * (log10(1 + e^2 * Cn^2)));
 % chebyshev lowpass and highpass attenuation in dB.
end

 figure; % opens new graph figure.
 plot(wx,AdB);
 xlabel('Frequency');
 ylabel('dB');
 if (t==0)
   %  title('Chebyshev Lowpass Filter');
   eval(sprintf('title('' %d pole Chebyshev Lowpass Filter '')',n))
 elseif (t==1)
   %  title('Chebyshev Highpass Filter');
   eval(sprintf('title('' %d pole Chebyshev Highpass Filter '')',n))
 end;
