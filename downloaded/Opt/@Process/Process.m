function [rp] = Process(basis,offset,Coeff)
% PROCESS class of sequence random processes
% rp is a wide-sense-stationary, zero-mean discrete-time process
% along with system information.  rp may be the sum of any number
% of basic independent random processes modified by LTI systems.
%
% PROCESS members:
%   ind   : array of indices into global table of base process inputs
%   sys   : associated cell array of accumulated systems (type optSequence) 
%
% class methods:
% constructor:
%   [rp]=Process(basis,offset,Coeff)
%       initializes rp as a wsszm process whose spectrum is defined by
%       shifted and weighted basis functions.  The triple
%       (basis,ofset,Coeff) is placed in a global table and is referred to 
%       through its index, allowing multiple processes to refer to the
%       same base process.
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
N=length(OPT_DATA.procs);
OPT_DATA.procs(N+1).basis=basis;    %init global table
OPT_DATA.procs(N+1).offset=offset;
OPT_DATA.procs(N+1).Coeff=Coeff;
OPT_DATA.procs(N+1).coeff=ifft(Coeff);
rp.ind=N+1;                  % pointer to base process
rp.sys{1}=optSequence([1]);  % delta function
rp = class(rp, 'Process');
superiorto('optSequence');   % ensures that Process methods are called first
