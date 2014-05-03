function [rp] = NDProcess(basis,param,freqs,Coeff)
% NDPROCESS class of sequence random processes
% rp is a wide-sense-stationary, zero-mean discrete-time process
% along with system information.  rp may be the sum of any number
% of basic independent random processes modified by LTI systems.
%
% NDPROCESS members:
%   ind   : array of indices into global table of base process inputs
%   sys   : associated cell array of accumulated systems (type optArray) 
%
% class methods:
% constructor:
%   [rp]=NDProcess(basis,param,freqs,Coeff)
%       initializes rp as a wsszm process whose spectrum is defined by
%       shifted and weighted basis functions.  The quadruple
%       (basis,param,freqs,Coeff) is placed in a global table and is 
%       referred to through its index, allowing multiple processes
%       to refer to the same base process.
%   basis : basis function for the process's PSD. Currently allowed
%       are 'Box', 'Triangle', 'Impulse' and 'Circle', if the PSD
%       is to be composed of a single type of basis function. For a
%       PSD composed of several types, basis must be a cell column
%       vector with each individual basis function named. For
%       example, {'Box'; 'Circle'; 'Circle'} specifies a PSD
%       composed of a 'Box' and two 'Circles'. 
%   param : parameters for basis functions. For PSD composed of a
%       single type of basis function, param should be a matrix, 
%       each row of which contains the parameters for another basis
%       function. For several types, param should be a cell column
%       vector with each entry the parameters for an individual
%       basis function.
%       'Box', 'Triangle' : width parameters are required, one
%       positive, real width for each dimension. For example, if
%       this is a one-type PSD, param should be a matrix, each row
%       of which contains the widths for another basis
%       function. For a several-type PSD, each 'Box' or 'Triangle'
%       entry should be a row vector.
%       'Circle' : currently, only 2-D is supported. A positive,
%       real radius parameter is required.
%       'Impulse' : no parameters required. For one-type PSD, use
%       the empty matrix []. For several-type PSD, each 'Impulse'
%       entry should be the empty matrix [].
%   freqs : matrix of frequency shifts. Each row gives the shifts
%       for another basis function. The PSD is the sum of basis
%       functions at each of the frequency shifts in freqs. The
%       width of the freqs matrix determines the dimension of the
%       process.
%   Coeff : vector of coefficients of basis functions. Must have
%       length equal to the number of rows of width and freqs.
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

dim = size(freqs,2);

if iscell(basis)
  % if multiple basis function types are specified
  if size(basis,2) ~= 1
    error('Cell array of basis function types must be a vector.');
  end
  if size(param,2) ~= 1
    error('Cell array of parameters must be a vector.');
  end
  if size(freqs,1) ~= size(basis,1)
    error(['If individual basis function types are specified, you must' ...
	   ' specify one for each frequency shift.']);
  end
  if size(freqs,1) ~= size(param,1)
    error(['If individual basis function types are specified, you must' ...
	   ' specify one parameter for each frequency shift.']);
  end
  rca = []; % list of all errors
  for qq=1:length(basis)
    if ~exist([basis{qq} 'Time'])
      error(['The basis function ' basis ' is undefined']);
    end
    [rc,newparam] = feval([basis{qq} 'Check'], param{qq}, [1 dim]);
    if ~isempty(rc)
      rca = [rca char(10) rc];
    end
  end
  if ~isempty(rca)
    error(rca);
  end
else
  % for single basis function type
  if ~exist([basis 'Time'])
    error(['The basis function ' basis ' is undefined']);
  end
  [rc,newparam] = feval([basis 'Check'], param, size(freqs));
  if ~isempty(rc)
    error(rc);
  end
end;

%---- REPLACE with appropriate check
if max(abs(imag(Coeff)))~=0
  error('The spectrum must be real.')
end;
if min(Coeff)<0
  warning(['Some coefficients are negative. Please ensure this is a' ...
	   ' valid PSD.']);
end

if length(Coeff) ~= size(freqs,1)
  error('vector of coefficients of incorrect length.')
end

disp([num2str(dim) '-D process created.']);
N=length(OPT_DATA.ndprocs);
OPT_DATA.ndprocs(N+1).dim = dim;
OPT_DATA.ndprocs(N+1).basis=basis;    %init global table
OPT_DATA.ndprocs(N+1).param=param;
OPT_DATA.ndprocs(N+1).freqs=freqs;
OPT_DATA.ndprocs(N+1).Coeff=Coeff(:)';
rp.ind=N+1;                  % pointer to base process
rp.sys{1}=optArray(zeros(1,dim),[1]);  % delta(n1, n2, ...) function
rp = class(rp, 'NDProcess');
superiorto('optArray');   % ensures that Process methods are called first
