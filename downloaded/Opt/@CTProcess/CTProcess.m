function [rp] = CTProcess(basis,scale,freqs,Coeff)
% CTPROCESS class of sequence random processes
% rp is a wide-sense-stationary, zero-mean continuous-time process
% along with system information.  rp may be the sum of any number
% of basic independent random processes modified by LTI systems.
%
% CTPROCESS members:
%   ind   : array of indices into global table of base process inputs
%   sys   : associated cell array of accumulated systems (type optGenSequence) 
%
% class methods:
% constructor:
%   [rp]=CTProcess(basis,scale,freqs,Coeff)
%       initializes rp as a wsszm process whose spectrum is defined by
%       shifted and weighted basis functions.  The quadruple
%       (basis,scale,freqs,Coeff) is placed in a global table and is 
%       referred to through its index, allowing multiple processes
%       to refer to the same base process.
%   basis : basis function for the process's PSD, for example 'box'
%       or 'triangle'
%   scale : frequency scale factor for basis functions
%   freqs : vector of frequency shifts. The PSD is the sum of basis
%       functions at each of the frequency shifts in freqs.
%   Coeff : vector of coefficients of basis functions. Must be the
%       same length as freqs.
%
% other methods:
%   [pool]=get_pool(rp)
%       if the process constains an optimizable system, then the
%       associated pool is returned. otherwise, 0 is returned
%   [pwr]=pwr(rp)
%       returns the power in process rp as an optimizable quadratic
%       quantity of type opt_quad.
%
% operators:
%       valid operators include most of those defined for systems, and
%       generally represent operations on the systems themselves
%   [rpsum]=plus(rpa,rpb)
%       sum of two random processes.  Any base processes shared by
%       rpa and rpb have their systems combined, the rest are concatenated
%   [rpdiff]=minus(rpa,rpb)
%       difference of two random processes
%   [rpmin]=uminus(rp)
%       negation of the process
%   [rpconj]=conj(rp)
%       conjugation of the process
%   [rpdic]=mrdivide(rp,d)
%       scalar division of a process
%   [rpconv]=times(a,b)
%       convolution of a process with an affine sequence (system)
global OPT_DATA;
if ~exist([basis 'Time'])
    error(['The basis function ' basis ' is undefined']);
end;
if (max(abs(imag(Coeff)))~=0 | min(Coeff)<0)
    error('The spectrum must be real and nonnegative.')
end;
if length(freqs) ~= length(Coeff)
    error('vectors of frequencies and coefficients are of different lengths.')
end
if prod(size(scale)) ~= 1
  error('scale must be a scalar')
end

[sfreqs,I] = sort(freqs(:)');
if ~isempty(find(abs(diff(sfreqs))<10*eps)) % since sfreqs is sorted check for neighboring matches
    error('duplicate entries in vector of frequencies');
end;
Coeff = Coeff(I);

N=length(OPT_DATA.ctprocs);
OPT_DATA.ctprocs(N+1).basis=basis;    %init global table
OPT_DATA.ctprocs(N+1).scale=scale;
OPT_DATA.ctprocs(N+1).freqs=sfreqs;
OPT_DATA.ctprocs(N+1).Coeff=Coeff(:)';
rp.ind=N+1;                  % pointer to base process
rp.sys{1}=optGenSequence([1]);  % delta function
rp = class(rp, 'CTProcess');
superiorto('optGenSequence');   % ensures that Process methods are called first
